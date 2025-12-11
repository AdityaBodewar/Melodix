import 'package:flutter/material.dart';
import 'package:frontend/handleApi/ApiService .dart';
import 'package:frontend/SongPlayerPage.dart';

class ArtistSongsPage extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ArtistSongsPage({
    Key? key,
    required this.artistId,
    required this.artistName,
  }) : super(key: key);

  @override
  _ArtistSongsPageState createState() => _ArtistSongsPageState();
}

class _ArtistSongsPageState extends State<ArtistSongsPage> {
  bool isLoading = true;
  List<dynamic> songs = [];

  @override
  void initState() {
    super.initState();
    loadArtistSongs();
  }

  Future<void> loadArtistSongs() async {
    final res = await ApiService.getArtistSongs(widget.artistId);

    if (res["status"] == 200) {
      setState(() {
        songs = res["data"]["songs"];
        isLoading = false;
      });
    } else {
      setState(() {
        songs = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artistName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : songs.isEmpty
          ? const Center(child: Text("This artist has no songs yet."))
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song["Image"],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              song["Title"],
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
