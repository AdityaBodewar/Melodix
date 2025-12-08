// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class SongPlayerPage extends StatefulWidget {
//   final String image;
//   final String title;
//   final String singer;
//   final String audioUrl;
//
//   const SongPlayerPage({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.singer,
//     required this.audioUrl,
//   });
//
//   @override
//   State<SongPlayerPage> createState() => _SongPlayerPageState();
// }
//
// class _SongPlayerPageState extends State<SongPlayerPage> {
//   final AudioPlayer _player = AudioPlayer();
//
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//
//   bool isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     playSong();
//
//     // Listen total duration
//     _player.onDurationChanged.listen((d) {
//       setState(() => _duration = d);
//     });
//
//     // Listen current position
//     _player.onPositionChanged.listen((p) {
//       setState(() => _position = p);
//     });
//
//     // Listen when song finishes
//     _player.onPlayerComplete.listen((_) {
//       setState(() {
//         isPlaying = false;
//         _position = Duration.zero;
//       });
//     });
//   }
//
//   Future<void> playSong() async {
//     print("AUDIO URL → ${widget.audioUrl}");
//
//     try {
//       await _player.stop();
//       await _player.setSourceUrl(widget.audioUrl);
//       await _player.resume();
//
//       setState(() => isPlaying = true);
//     } catch (e) {
//       print("PLAY ERROR → $e");
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.keyboard_arrow_down, size: 32),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Now Playing"),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Song Image
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(widget.image, height: 260),
//             ),
//           ),
//
//           // Title
//           Text(
//             widget.title,
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//
//           // Singer
//           Text(
//             widget.singer,
//             style: const TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Seekbar
//           Slider(
//             value: _position.inSeconds.toDouble(),
//             max: _duration.inSeconds.toDouble(),
//             onChanged: (value) async {
//               final pos = Duration(seconds: value.toInt());
//               await _player.seek(pos);
//             },
//           ),
//
//           // Time Row
//           Text(
//             "${formatTime(_position)} / ${formatTime(_duration)}",
//             style: const TextStyle(color: Colors.white70),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Controls Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.skip_previous, color: Colors.white, size: 40),
//
//               const SizedBox(width: 20),
//
//               // Play / Pause button
//               IconButton(
//                 iconSize: 60,
//                 color: Colors.white,
//                 icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
//                 onPressed: () async {
//                   if (isPlaying) {
//                     await _player.pause();
//                   } else {
//                     await _player.resume();
//                   }
//                   setState(() => isPlaying = !isPlaying);
//                 },
//               ),
//
//               const SizedBox(width: 20),
//
//               Icon(Icons.skip_next, color: Colors.white, size: 40),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   String formatTime(Duration d) {
//     String two(int n) => n.toString().padLeft(2, "0");
//     return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
//   }
// }


import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class SongPlayerPage extends StatefulWidget {
  final List songs;        // full list of songs
  final int currentIndex;  // selected index

  const SongPlayerPage({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final AudioPlayer _player = AudioPlayer();

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

    playSong();

    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _player.onPlayerComplete.listen((_) {
      playNext();
    });
  }

  // PLAY SONG
  Future<void> playSong() async {
    try {
      await _player.stop();
      await _player.setSourceUrl(currentSong["Song"]);
      await _player.resume();

      setState(() => isPlaying = true);
    } catch (e) {
      print("ERROR Playing Song → $e");
    }
  }

  // NEXT SONG
  void playNext() {
    if (index < widget.songs.length - 1) {
      index++;
      setState(() {
        currentSong = widget.songs[index];
      });
      playSong();
    }
  }

  // PREVIOUS SONG
  void playPrevious() {
    if (index > 0) {
      index--;
      setState(() {
        currentSong = widget.songs[index];
      });
      playSong();
    }
  }

  // SAVE DOWNLOAD INFO
  Future<void> saveDownloadedSong(Map song) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> downloaded = prefs.getStringList("downloadedSongs") ?? [];
      downloaded.add(jsonEncode(song));

      await prefs.setStringList("downloadedSongs", downloaded);
    } catch (e) {
      print("SharedPreferences Save Error → $e");
    }
  }

  // DOWNLOAD SONG
  Future<void> downloadSong() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory("${dir.path}/downloads");

      if (!await downloadDir.exists()) {
        await downloadDir.create();
      }

      final filePath = "${downloadDir.path}/${currentSong["Title"]}.mp3";
      final file = File(filePath);

      // ❗ Check if already downloaded
      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Already Downloaded!")),
        );
        return;
      }

      // DOWNLOAD
      await Dio().download(currentSong["Song"], filePath);

      await saveDownloadedSong({
        "title": currentSong["Title"],
        "singer": currentSong["Singer"],
        "image": currentSong["Image"],
        "filePath": filePath
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloaded Successfully!")),
      );

    } catch (e) {
      print("Download Error → $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download Failed!")),
      );
    }
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Now Playing", style: TextStyle(color: Colors.white)),
        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: () {
              setState(() => isLiked = !isLiked);
            },
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == "download") downloadSong();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "download",
                child: Text("Download Song"),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Song Image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(currentSong["Image"], height: 260),
            ),
          ),

          // Title
          Text(
            currentSong["Title"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Singer
          Text(
            currentSong["Singer"],
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 20),

          // Seek Bar
          Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) async {
              final pos = Duration(seconds: value.toInt());
              await _player.seek(pos);
            },
          ),

          Text(
            "${formatTime(_position)} / ${formatTime(_duration)}",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 30),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                color: Colors.white,
                iconSize: 40,
                onPressed: playPrevious,
              ),

              const SizedBox(width: 20),

              IconButton(
                iconSize: 60,
                color: Colors.white,
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
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
                color: Colors.white,
                iconSize: 40,
                onPressed: playNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }
}
