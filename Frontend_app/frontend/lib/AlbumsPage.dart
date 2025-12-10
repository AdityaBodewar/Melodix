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

    albums = stored.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
    setState(() {});
  }

  Future<void> saveAlbums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encoded = albums.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList("albumsList", encoded);
  }

  void createAlbumDialog() {
    TextEditingController nameController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(
          "Create Album",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Album name",
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
          ),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;

              albums.add({"name": nameController.text.trim(), "songs": []});

              saveAlbums();
              setState(() {});
              Navigator.pop(context);
            },
            child: Text("Create",
                style: TextStyle(color: isDark ? Colors.blue : Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  void renameAlbumDialog(int index) {
    TextEditingController controller =
    TextEditingController(text: albums[index]["name"]);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(
          "Rename Album",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Album Name",
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel",
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save",
                style: TextStyle(color: isDark ? Colors.blue : Colors.blueAccent)),
            onPressed: () {
              albums[index]["name"] = controller.text.trim();
              saveAlbums();
              setState(() {});
              Navigator.pop(context);
            },
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        title: Text("Albums",
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: isDark ? Colors.white : Colors.black),
            onPressed: createAlbumDialog,
          )
        ],
      ),

      body: albums.isEmpty
          ? Center(
        child: Text(
          "No Albums",
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          final songs = album["songs"];

          return Card(
            color: isDark ? Color(0xFF2A2A2A) : Color(0xFFF2F2F2),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: songs.isEmpty
                    ? Icon(Icons.folder,
                    size: 45,
                    color: isDark ? Colors.orange : Colors.orangeAccent)
                    : Image.network(
                  songs[0]["image"],
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(
                album["name"],
                style:
                TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              subtitle: Text(
                "${songs.length} songs",
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54),
              ),

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
                  backgroundColor: isDark ? Colors.black : Colors.white,
                  context: context,
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit,
                            color: isDark ? Colors.white : Colors.black),
                        title: Text("Rename Album",
                            style: TextStyle(
                                color:
                                isDark ? Colors.white : Colors.black)),
                        onTap: () {
                          Navigator.pop(context);
                          renameAlbumDialog(index);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete,
                            color: isDark ? Colors.red : Colors.redAccent),
                        title: Text("Delete Album",
                            style: TextStyle(
                                color:
                                isDark ? Colors.red : Colors.redAccent)),
                        onTap: () {
                          Navigator.pop(context);
                          deleteAlbum(index);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.library_music,
                            color: isDark ? Colors.white : Colors.black),
                        title: Text("Add Songs",
                            style: TextStyle(
                                color:
                                isDark ? Colors.white : Colors.black)),
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
