import 'package:flutter/material.dart';
import 'SongPlayerPage.dart';

class AllSongsPage extends StatelessWidget {
  final List songs;

  const AllSongsPage({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Songs")),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65, // <-- Adjusted
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
                      image: song["Image"],
                      title: song["Title"],
                      singer: song["Singer"],
                      audioUrl: song["Song"],
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    song["Title"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),

    );
  }
}
