import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/MusicController.dart';

class OfflinePlayerPage extends StatefulWidget {
  final String title;
  final String singer;
  final String image;
  final String filePath;

  const OfflinePlayerPage({
    super.key,
    required this.title,
    required this.singer,
    required this.image,
    required this.filePath,
  });

  @override
  State<OfflinePlayerPage> createState() => _OfflinePlayerPageState();
}

class _OfflinePlayerPageState extends State<OfflinePlayerPage> {
  // GLOBAL PLAYER
  final AudioPlayer _player = MusicController.player;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    //  If SAME offline song already playing → DO NOT restart
    if (MusicController.isOffline == true &&
        MusicController.localFilePath == widget.filePath &&
        MusicController.isPlaying == true)
    {
      isPlaying = true;

      // Sync duration + position
      _player.getDuration().then((d) {
        if (d != null) setState(() => _duration = d);
      });

      _player.getCurrentPosition().then((p) {
        if (p != null) setState(() => _position = p);
      });
    }
    else
    {
      //  Play new offline song
      playSong();
    }

    // Listen for duration updates
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    // Listen for playing position updates
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });


  }

  Future<void> playSong() async {
    try {
      final player = MusicController.player;

      // Stop any previous song (online/offline)
      await player.stop();

      //  Play offline song
      await player.setSource(DeviceFileSource(widget.filePath));
      await player.resume();

      MusicController.title = widget.title;
      MusicController.singer = widget.singer;
      MusicController.image = widget.image;

      MusicController.isOffline = true;
      MusicController.localFilePath = widget.filePath;
      MusicController.isPlaying = true;

      setState(() => isPlaying = true);

    } catch (e) {
      print("Offline play error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down,
              color: textColor, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Now Playing", style: TextStyle(color: textColor)),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.image,
                height: 260,
                width: 260,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Text(
            widget.title,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(widget.singer,
              style: TextStyle(color: subtitleColor, fontSize: 16)),

          const SizedBox(height: 20),

          Slider(
            value: _position.inSeconds.toDouble(),
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

          IconButton(
            iconSize: 60,
            color: textColor,
            icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
            onPressed: () async {
              if (isPlaying) {
                await _player.pause();
              } else {
                await _player.resume();
              }
              setState(() => isPlaying = !isPlaying);
              MusicController.isPlaying = isPlaying; // sync bottom bar
            },
          ),
        ],
      ),
    );
  }

  // Time formatting function
  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }
}
