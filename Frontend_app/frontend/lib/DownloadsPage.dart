import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/OfflinePlayerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<Map<String, dynamic>> downloadedSongs = [];
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadDownloadedSongs();
  }

  Future<void> loadDownloadedSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList("downloadedSongs") ?? [];

    downloadedSongs = data
        .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(jsonDecode(e)),
    )
        .toList();

    setState(() {});
  }

  Future<void> deleteSong(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final song = downloadedSongs[index];

    final file = File(song["filePath"]);
    if (await file.exists()) {
      await file.delete();
    }

    List<String> data = prefs.getStringList("downloadedSongs") ?? [];
    data.removeAt(index);
    await prefs.setStringList("downloadedSongs", data);

    setState(() {
      downloadedSongs.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Song Deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ THEME COLORS (AUTO FROM Main Theme)
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white60
        : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: Text(
          "Downloaded Songs",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),

      body: downloadedSongs.isEmpty
          ? Center(
        child: Text(
          "No Downloaded Songs",
          style: TextStyle(color: subtitleColor),
        ),
      )
          : ListView.builder(
        itemCount: downloadedSongs.length,
        itemBuilder: (context, index) {
          final song = downloadedSongs[index];

          return ListTile(
            leading: const Icon(Icons.music_note, color: Colors.blue),

            title: Text(
              song["title"],
              style: TextStyle(color: textColor),
            ),

            subtitle: Text(
              song["singer"],
              style: TextStyle(color: subtitleColor),
            ),

            trailing: Icon(Icons.play_arrow, color: textColor),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OfflinePlayerPage(
                    title: song["title"],
                    singer: song["singer"],
                    image: song["image"],
                    filePath: song["filePath"],
                  ),
                ),
              );
            },

            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: bgColor,
                  title: Text(
                    "Delete Song?",
                    style: TextStyle(color: textColor),
                  ),
                  content: Text(
                    "Do you want to delete '${song["title"]}'?",
                    style: TextStyle(color: subtitleColor),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        deleteSong(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
