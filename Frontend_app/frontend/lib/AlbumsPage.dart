// 📂 lib/AlbumsPage.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AlbumSongsPage.dart';
import 'SelectSongsPage.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  List<Map<String, dynamic>> albums = [];

  @override
  void initState() {
    super.initState();
    loadAlbums();
  }

  Future<void> loadAlbums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> stored = prefs.getStringList("albumsList") ?? [];

    albums = stored
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();

    setState(() {});
  }

  Future<void> saveAlbums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encoded = albums.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList("albumsList", encoded);
  }

  void createAlbumDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title:
        const Text("Create Album", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: "Album name",
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;

              albums.add({
                "name": nameController.text.trim(),
                "songs": [],
              });

              saveAlbums();
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void renameAlbumDialog(int index) {
    TextEditingController controller =
    TextEditingController(text: albums[index]["name"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title:
        const Text("Rename Album", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Album Name",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Save"),
            onPressed: () {
              albums[index]["name"] = controller.text.trim();
              saveAlbums();
              setState(() {});
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void deleteAlbum(int index) {
    albums.removeAt(index);
    saveAlbums();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Album Deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Albums"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createAlbumDialog,
          )
        ],
      ),

      body: albums.isEmpty
          ? const Center(
        child: Text("No Albums", style: TextStyle(color: Colors.white70)),
      )
          : ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          final songs = album["songs"];

          return Card(
            color: const Color(0xFF2A2A2A),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: songs.isEmpty
                    ? const Icon(Icons.folder,
                    size: 45, color: Colors.orange)
                    : Image.network(
                  songs[0]["image"],
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(album["name"],
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text("${songs.length} songs",
                  style: const TextStyle(color: Colors.white54)),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AlbumSongsPage(albumData: album),
                  ),
                ).then((_) => loadAlbums());
              },

              onLongPress: () {
                showModalBottomSheet(
                  backgroundColor: Colors.black,
                  context: context,
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit,
                            color: Colors.white),
                        title: const Text("Rename Album",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          renameAlbumDialog(index);
                        },
                      ),
                      ListTile(
                        leading:
                        const Icon(Icons.delete, color: Colors.red),
                        title: const Text("Delete Album",
                            style: TextStyle(color: Colors.red)),
                        onTap: () {
                          Navigator.pop(context);
                          deleteAlbum(index);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.library_music,
                            color: Colors.white),
                        title: const Text("Add Songs",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectSongsPage(
                                albumIndex: index,
                                albumData: album,
                              ),
                            ),
                          ).then((_) => loadAlbums());
                        },
                      ),
                    ],
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
