import 'dart:io';                                 // File delete / exist check ke liye
import 'dart:convert';                            // jsonEncode / jsonDecode ke liye
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Offline audio play ke liye
import 'package:frontend/OfflinePlayerPage.dart'; // Offline player screen
import 'package:shared_preferences/shared_preferences.dart'; // Local storage (key-value)

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {

  /// Ye list SharedPreferences me saved har downloaded song ka data store karegi.
  /// Har song ek Map hai: {title, singer, image, filePath}
  List<Map<String, dynamic>> downloadedSongs = [];

  /// Offline music play ke liye AudioPlayer object
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadDownloadedSongs(); // Screen load hote hi downloaded songs fetch karo
  }

  /// 🔹 SharedPreferences se downloaded songs list load karna
  Future<void> loadDownloadedSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // "downloadedSongs" key me list of String (JSON) stored hai
    List<String> data = prefs.getStringList("downloadedSongs") ?? [];

    // Har String ko JSON se Map me convert karo
    downloadedSongs = data
        .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(jsonDecode(e)),
    )
        .toList();

    setState(() {}); // UI ko update karo
  }

  /// 🔹 Song ko storage + SharedPreferences + UI se delete karna
  Future<void> deleteSong(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final song = downloadedSongs[index];

    // 1️⃣ File system se MP3 delete karo
    final file = File(song["filePath"]);
    if (await file.exists()) {
      await file.delete();
    }

    // 2️⃣ SharedPreferences list se entry remove karo
    List<String> data = prefs.getStringList("downloadedSongs") ?? [];
    data.removeAt(index);
    await prefs.setStringList("downloadedSongs", data);

    // 3️⃣ Local list se bhi song remove karo (UI update ke liye)
    setState(() {
      downloadedSongs.removeAt(index);
    });

    // 4️⃣ User ko snackbar se feedback do
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Song Deleted")),
    );
  }

  /// (Optional) Direct list se hi play karna ho to use kar sakte ho
  void playOffline(String filePath) async {
    await _player.stop();
    await _player.play(DeviceFileSource(filePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Downloaded Songs"),
        backgroundColor: Colors.black,
      ),

      /// Agar koi downloaded song nahi hai
      body: downloadedSongs.isEmpty
          ? const Center(
        child: Text(
          "No Downloaded Songs",
          style: TextStyle(color: Colors.white70),
        ),
      )

      /// Agar songs available hain to list dikhao
          : ListView.builder(
        itemCount: downloadedSongs.length,
        itemBuilder: (context, index) {
          final song = downloadedSongs[index];

          return ListTile(
            leading: const Icon(
              Icons.music_note,
              color: Colors.blue,
            ),

            /// Song title
            title: Text(
              song["title"],
              style: const TextStyle(color: Colors.white),
            ),

            /// Singer name
            subtitle: Text(
              song["singer"],
              style: const TextStyle(color: Colors.white60),
            ),

            /// Right side play icon
            trailing: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),

            /// 🔹 Tap → Offline player page open (full UI with seekbar, cover, etc.)
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

            /// 🔹 Long press → Delete dialog
            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Song?"),
                  content: Text(
                    "Do you want to delete '${song["title"]}'?",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // close dialog
                        deleteSong(index);      // actual delete
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
