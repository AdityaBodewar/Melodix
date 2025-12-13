import 'package:flutter/material.dart';
import 'package:frontend/handleApi/ApiService%20.dart';
import 'package:frontend/SongPlayerPage.dart';

class ArtistSongsPage extends StatefulWidget {
  final dynamic artist;

  const ArtistSongsPage({super.key, required this.artist});

  @override
  State<ArtistSongsPage> createState() => _ArtistSongsPageState();
}

class _ArtistSongsPageState extends State<ArtistSongsPage> {
  bool isLoading = true;
  List<dynamic> songs = [];
  String error = "";

  @override
  void initState() {
    super.initState();
    loadArtistSongs();
  }

  Future<void> loadArtistSongs() async {
    try {
      final artistId = widget.artist["_id"] is Map
          ? widget.artist["_id"]["\$oid"]
          : widget.artist["_id"];

      final data = await ApiService.fetchSongsOfArtist(artistId);

      setState(() {
        songs = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Something went wrong";
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artist["Fullname"] ?? "Artist"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : error.isNotEmpty
          ? Center(child: Text(error))

          : songs.isEmpty
          ? const Center(
        child: Text(
          "No songs available",
          style: TextStyle(fontSize: 16),
        ),
      )

          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                song["Image"],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.music_note),
              ),
            ),
            title: Text(song["Title"] ?? "Unknown"),
            subtitle: Text(song["Singer"] ?? ""),
            trailing: const Icon(Icons.play_arrow),

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
          );
        },
      ),
    );
  }
}
