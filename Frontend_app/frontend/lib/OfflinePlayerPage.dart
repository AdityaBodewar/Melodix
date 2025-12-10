import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    playSong();

    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });
  }

  Future<void> playSong() async {
    await _player.stop();
    await _player.play(DeviceFileSource(widget.filePath));
    setState(() => isPlaying = true);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ THEME COLORS
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
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
        title: Text("Now Playing",
            style: TextStyle(color: textColor)),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // COVER IMAGE
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

          // TITLE
          Text(
            widget.title,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // SINGER
          Text(
            widget.singer,
            style: TextStyle(color: subtitleColor, fontSize: 16),
          ),

          const SizedBox(height: 20),

          // SEEK BAR
          Slider(
            value: _position.inSeconds.toDouble(),
            max: (_duration.inSeconds == 0 ? 1 : _duration.inSeconds).toDouble(),
            activeColor: Colors.blue,
            onChanged: (value) async {
              final pos = Duration(seconds: value.toInt());
              await _player.seek(pos);
            },
          ),

          // TIME INDICATORS
          Text(
            "${formatTime(_position)} / ${formatTime(_duration)}",
            style: TextStyle(color: subtitleColor),
          ),

          const SizedBox(height: 30),

          // PLAY PAUSE BUTTON
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
            },
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
