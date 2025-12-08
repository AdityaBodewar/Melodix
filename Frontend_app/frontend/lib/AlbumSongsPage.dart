// 📂 lib/AlbumSongsPage.dart

import 'package:flutter/material.dart';
import 'package:frontend/OfflinePlayerPage.dart';

class AlbumSongsPage extends StatelessWidget {
  final Map albumData;

  const AlbumSongsPage({super.key, required this.albumData});

  @override
  Widget build(BuildContext context) {
    List songs = albumData["songs"];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(albumData["name"]),
        backgroundColor: Colors.black,
      ),

      body: songs.isEmpty
          ? const Center(
          child: Text("No songs in this album",
              style: TextStyle(color: Colors.white70)))
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return ListTile(
            leading: Image.network(song["image"],
                width: 50, height: 50, fit: BoxFit.cover),

            title: Text(song["title"],
                style: const TextStyle(color: Colors.white)),

            subtitle: Text(song["singer"],
                style: const TextStyle(color: Colors.white54)),

            trailing:
            const Icon(Icons.play_arrow, color: Colors.white),

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
          );
        },
      ),
    );
  }
}
