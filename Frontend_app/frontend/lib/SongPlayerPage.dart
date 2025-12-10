import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:frontend/MusicController.dart';

import 'dart:io';

class SongPlayerPage extends StatefulWidget {
  final List songs;
  final int currentIndex;

  const SongPlayerPage({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  // final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _player = MusicController.player;   // 🔥 global player


  late int index;
  late Map currentSong;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool isPlaying = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    index = widget.currentIndex;
    currentSong = widget.songs[index];

    // Play only if switching song
    if (MusicController.currentIndex != index) {
      playSong();
    } else {
      // sync playing state
      setState(() => isPlaying = MusicController.isPlaying);
    }

    // ⭐ Sync UI with already playing song
    _player.getCurrentPosition().then((p) {
      if (p != null) {
        setState(() => _position = p);
      }
    });

    _player.getDuration().then((d) {
      if (d != null) {
        setState(() => _duration = d);
      }
    });

    // listeners
    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _player.onPlayerComplete.listen((_) => playNext());
  }


  // ▶ PLAY SONG
  Future<void> playSong() async {
    try {
      await _player.stop();
      await _player.setSourceUrl(currentSong["Song"]);
      await _player.resume();
      setState(() => isPlaying = true);
    } catch (_) {}

    MusicController.updateSong(
      newTitle: currentSong["Title"],
      newSinger: currentSong["Singer"],
      newImage: currentSong["Image"],
      index: index,
      songList: widget.songs,
    );


  }

  // ⏭ NEXT SONG
  void playNext() {
    if (index < widget.songs.length - 1) {
      index++;
      setState(() => currentSong = widget.songs[index]);
      playSong();
    }
  }

  // ⏮ PREVIOUS SONG
  void playPrevious() {
    if (index > 0) {
      index--;
      setState(() => currentSong = widget.songs[index]);
      playSong();
    }
  }

  // 💾 Save Download Info
  Future<void> saveDownloadedSong(Map song) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloaded = prefs.getStringList("downloadedSongs") ?? [];
    downloaded.add(jsonEncode(song));
    await prefs.setStringList("downloadedSongs", downloaded);
  }

  // ⬇ DOWNLOAD SONG
  Future<void> downloadSong() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory("${dir.path}/downloads");

      if (!await downloadDir.exists()) await downloadDir.create();

      final filePath = "${downloadDir.path}/${currentSong["Title"]}.mp3";
      final file = File(filePath);

      if (await file.exists()) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Already Downloaded!")));
        return;
      }

      await Dio().download(currentSong["Song"], filePath);

      await saveDownloadedSong({
        "title": currentSong["Title"],
        "singer": currentSong["Singer"],
        "image": currentSong["Image"],
        "filePath": filePath,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Downloaded Successfully!")));
    } catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Download Failed!")));
    }
  }

  // @override
  // void dispose() {
  //   _player.dispose();
  //   super.dispose();
  // }

  // TIME FORMATTER
  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, size: 32, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Now Playing",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent),
            onPressed: () => setState(() => isLiked = !isLiked),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textColor),
            onSelected: (value) {
              if (value == "download") downloadSong();
            },
            itemBuilder: (_) =>
            [const PopupMenuItem(value: "download", child: Text("Download Song"))],
          ),
        ],
      ),

      // ⭐ SCROLLABLE BODY (NO OVERFLOW EVER)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🎵 ALBUM ART
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  currentSong["Image"],
                  height: 260,
                  width: 260,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // 🎼 TITLE
              Text(
                currentSong["Title"],
                style: TextStyle(
                    color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),

              // 🎤 SINGER
              Text(
                currentSong["Singer"],
                style: TextStyle(color: subtitleColor, fontSize: 16),
              ),

              const SizedBox(height: 20),

              // 🎚 SEEK BAR
              Slider(
                value: _duration.inSeconds == 0
                    ? 0
                    : _position.inSeconds.clamp(0, _duration.inSeconds).toDouble(),

                max: (_duration.inSeconds == 0 ? 1 : _duration.inSeconds).toDouble(),

                activeColor: Colors.blue,

                onChanged: (value) async {
                  await _player.seek(Duration(seconds: value.toInt()));
                },
              ),


              Text(
                "${formatTime(_position)} / ${formatTime(_duration)}",
                style: TextStyle(color: subtitleColor),
              ),

              const SizedBox(height: 30),

              // ▶ CONTROLS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    color: textColor,
                    iconSize: 40,
                    onPressed: playPrevious,
                  ),

                  const SizedBox(width: 20),

                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                    color: textColor,
                    iconSize: 70,
                    onPressed: () async {
                      if (isPlaying) {
                        await _player.pause();
                      } else {
                        await _player.resume();
                      }
                      setState(() => isPlaying = !isPlaying);
                    },
                  ),

                  const SizedBox(width: 20),

                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    color: textColor,
                    iconSize: 40,
                    onPressed: playNext,
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
