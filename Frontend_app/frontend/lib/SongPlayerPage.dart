import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongPlayerPage extends StatefulWidget {
  final String image;
  final String title;
  final String singer;
  final String audioUrl;

  const SongPlayerPage({
    super.key,
    required this.image,
    required this.title,
    required this.singer,
    required this.audioUrl,
  });

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    playSong();

    // Listen total duration
    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    // Listen current position
    _player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    // Listen when song finishes
    _player.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> playSong() async {
    print("AUDIO URL → ${widget.audioUrl}");

    try {
      await _player.stop();
      await _player.setSourceUrl(widget.audioUrl);
      await _player.resume();

      setState(() => isPlaying = true);
    } catch (e) {
      print("PLAY ERROR → $e");
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
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Now Playing"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Song Image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(widget.image, height: 260),
            ),
          ),

          // Title
          Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // Singer
          Text(
            widget.singer,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 20),

          // Seekbar
          Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) async {
              final pos = Duration(seconds: value.toInt());
              await _player.seek(pos);
            },
          ),

          // Time Row
          Text(
            "${formatTime(_position)} / ${formatTime(_duration)}",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 30),

          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.skip_previous, color: Colors.white, size: 40),

              const SizedBox(width: 20),

              // Play / Pause button
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

              Icon(Icons.skip_next, color: Colors.white, size: 40),
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
