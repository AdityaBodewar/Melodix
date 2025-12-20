import 'package:flutter/material.dart';
import 'package:frontend/handleApi/ApiService .dart';
import 'package:frontend/SongPlayerPage.dart';

class ArtistSongsPage extends StatefulWidget {
  final dynamic artist;

  const ArtistSongsPage({Key? key, required this.artist}) : super(key: key);

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
      final String artistId =
      widget.artist["_id"] is Map
          ? widget.artist["_id"]["\$oid"]
          : widget.artist["_id"].toString();

      final result = await ApiService.fetchSongsOfArtist(artistId);

      setState(() {
        songs = result;
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
    final artistName = widget.artist["Fullname"] ?? "Artist";
    final artistImage = widget.artist["Image"] ?? "";

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : error.isNotEmpty
          ? Center(
        child: Text(
          error,
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      )

          : CustomScrollView(
        slivers: [

          /// 🔝 APP BAR WITH IMAGE
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                artistName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    artistImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.person,
                          size: 120,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          songs.isEmpty
              ? const SliverFillRemaining(
            child: Center(
              child: Text(
                "No songs available",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )

              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final song = songs[index];

                return ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  title: Text(
                    song["Title"] ?? "Unknown",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

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
              childCount: songs.length,
            ),
          ),
        ],
      ),
    );
  }
}
