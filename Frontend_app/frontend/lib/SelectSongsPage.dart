
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectSongsPage extends StatefulWidget {
  final int albumIndex;
  final Map albumData;

  const SelectSongsPage({
    super.key,
    required this.albumIndex,
    required this.albumData,
  });

  @override
  State<SelectSongsPage> createState() => _SelectSongsPageState();
}

class _SelectSongsPageState extends State<SelectSongsPage> {
  List<dynamic> allSongs = [];
  List<dynamic> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    loadDownloadedSongs();
  }

  Future<void> loadDownloadedSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList("downloadedSongs") ?? [];

    allSongs = data.map((e) => jsonDecode(e)).toList();

    setState(() {});
  }

  Future<void> saveAlbum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> stored = prefs.getStringList("albumsList") ?? [];
    List<Map<String, dynamic>> albums =
    stored.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();

    albums[widget.albumIndex]["songs"] = selectedSongs;

    List<String> encoded = albums.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList("albumsList", encoded);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title:
        Text("Add Songs to ${widget.albumData["name"]}"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: saveAlbum,
          )
        ],
      ),

      body: allSongs.isEmpty
          ? const Center(
          child: Text("No downloaded songs",
              style: TextStyle(color: Colors.white70)))
          : ListView.builder(
        itemCount: allSongs.length,
        itemBuilder: (context, index) {
          final song = allSongs[index];

          return CheckboxListTile(
            activeColor: Colors.blue,
            checkColor: Colors.white,
            value: selectedSongs.contains(song),

            title: Text(song["title"],
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(song["singer"],
                style: const TextStyle(color: Colors.white54)),

            onChanged: (value) {
              setState(() {
                if (value!) {
                  selectedSongs.add(song);
                } else {
                  selectedSongs.remove(song);
                }
              });
            },
          );
        },
      ),
    );
  }
}
