import 'package:flutter/material.dart';
import 'package:frontend/AlbumsPage.dart';
import 'package:frontend/DownloadsPage.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/Registerpage.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mylibrary extends StatefulWidget {
  const Mylibrary({Key? key}) : super(key: key);

  @override
  State<Mylibrary> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<Mylibrary> {
  int downloadedCount = 0;

  List<Map<String, String>> libraryItems = [
    {'icon': 'album', 'title': 'Albums', 'subtitle': ''},
    {'icon': 'person', 'title': 'Artists', 'subtitle': '0 artists'},
    {'icon': 'download', 'title': 'Downloads', 'subtitle': ''},
  ];

  @override
  void initState() {
    super.initState();
    loadDownloadedCount();
  }

  Future<void> loadDownloadedCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloaded = prefs.getStringList("downloadedSongs") ?? [];

    setState(() {
      downloadedCount = downloaded.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token = prefs.getString("token");

                  final isDark = Theme.of(context).brightness == Brightness.dark;

                  // IF USER IS LOGGED IN  GO TO PROFILE PAGE
                  if (token != null && token.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Profilepage()),
                    );
                    return;
                  }

                  //  IF NOT LOGGED IN SHOW LOGIN / REGISTER OPTIONS
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Account Options",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Divider(
                            height: 1,
                            color: isDark ? Colors.white24 : Colors.black12,
                          ),

                          // LOGIN BTN
                          ListTile(
                            leading: Icon(Icons.login,
                                color: isDark ? Colors.white : Colors.black87),
                            title: Text("Login",
                                style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                              );
                            },
                          ),

                          // REGISTER BTN
                          ListTile(
                            leading: Icon(Icons.app_registration,
                                color: isDark ? Colors.white : Colors.black87),
                            title: Text("Register",
                                style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RegisterPage()),
                              );
                            },
                          ),

                          // CANCEL
                          ListTile(
                            leading: const Icon(Icons.close, color: Colors.redAccent),
                            title: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: libraryItems.length,
        itemBuilder: (context, index) {
          return _buildLibraryItem(
            _getIcon(libraryItems[index]['icon']!),
            libraryItems[index]['title']!,
            libraryItems[index]['subtitle']!,
            textColor,
          );
        },
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'playlist_play':
        return Icons.playlist_play;
      case 'album':
        return Icons.album;
      case 'person':
        return Icons.person;
      case 'download':
        return Icons.download;
      case 'history':
        return Icons.history;
      default:
        return Icons.music_note;
    }
  }

  Widget _buildLibraryItem(
      IconData icon, String title, String subtitle, Color? textColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.grey : Colors.black54;

    return Card(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 30),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        subtitle: Text(
          title == "Downloads" ? "$downloadedCount songs" : subtitle,
          style: TextStyle(color: subtitleColor, fontSize: 14),
        ),
        trailing: Icon(Icons.chevron_right, color: subtitleColor),
        onTap: () {
          if (title == "Downloads") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DownloadsPage()),
            );
          }
          if (title == "Albums") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AlbumsPage()),
            );
          }
        },
      ),
    );
  }
}
