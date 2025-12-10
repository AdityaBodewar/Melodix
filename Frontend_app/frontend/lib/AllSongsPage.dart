import 'package:flutter/material.dart';
import 'SongPlayerPage.dart';

class AllSongsPage extends StatelessWidget {
  final List songs;

  const AllSongsPage({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardTextColor = Theme.of(context).textTheme.bodyMedium?.color;
    final appbarColor = Theme.of(context).appBarTheme.backgroundColor;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: appbarColor,
        iconTheme: IconThemeData(color: cardTextColor),
        title: Text(
          "All Songs",
          style: TextStyle(color: cardTextColor),
        ),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 albums per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),

        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongPlayerPage(
                    songs: songs,
                    currentIndex: index,
                  ),
                ),
              );
            },

            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: Image.network(
                      song["Image"],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.music_note, size: 40),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  song["Title"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cardTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
