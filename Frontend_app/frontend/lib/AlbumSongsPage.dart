import 'package:flutter/material.dart';
import 'package:frontend/OfflinePlayerPage.dart';

class AlbumSongsPage extends StatelessWidget {
  final Map albumData;

  const AlbumSongsPage({super.key, required this.albumData});

  @override
  Widget build(BuildContext context) {
    List songs = albumData["songs"];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        title: Text(
          albumData["name"],
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),

      body: songs.isEmpty
          ? Center(
        child: Text(
          "No songs in this album",
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  song["image"],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(
                song["title"],
                style:
                TextStyle(color: isDark ? Colors.white : Colors.black),
              ),

              subtitle: Text(
                song["singer"],
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54),
              ),

              trailing: Icon(
                Icons.play_arrow,
                color: isDark ? Colors.white : Colors.black87,
              ),

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
            ),
          );
        },
      ),
    );
  }
}
