import 'package:flutter/material.dart';
import 'package:frontend/handleApi/ApiService .dart';
import 'ArtistSongsPage.dart';

class AllArtistsPage extends StatefulWidget {
  const AllArtistsPage({super.key});

  @override
  State<AllArtistsPage> createState() => _AllArtistsPageState();
}

class _AllArtistsPageState extends State<AllArtistsPage> {
  List<Map<String, dynamic>> artists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadArtists();
  }

  Future<void> loadArtists() async {
    try {
      final data = await ApiService.fetchAllArtists();

      setState(() {
        artists = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      print("Artist load error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(title: const Text("All Artists")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artists.isEmpty
          ? const Center(child: Text("No artists found"))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];

          final String artistId =
              artist["_id"]?.toString() ?? "";
          final String name =
              artist["Fullname"]?.toString() ?? "Unknown Artist";
          final String imageUrl =
              artist["Profile"]?.toString() ?? "";

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArtistSongsPage(
                    artist: artist,
                  ),
                ),
              );

            },
            child: Column(
              children: [
                Expanded(
                  child: ClipOval(
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 40),
                    )
                        : const Icon(Icons.person, size: 40),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
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
