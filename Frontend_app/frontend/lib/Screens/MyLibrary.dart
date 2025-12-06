import 'package:flutter/material.dart';

class Mylibrary extends StatefulWidget {
  const Mylibrary({Key? key}) : super(key: key);

  @override
  State<Mylibrary> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<Mylibrary> {
  // Dynamic data for future updates
  List<Map<String, String>> libraryItems = [
    {'icon': 'favorite', 'title': 'Liked Songs', 'subtitle': '45 songs'},
    {'icon': 'playlist_play', 'title': 'Playlists', 'subtitle': '12 playlists'},
    {'icon': 'album', 'title': 'Albums', 'subtitle': '23 albums'},
    {'icon': 'person', 'title': 'Artists', 'subtitle': '34 artists'},
    {'icon': 'download', 'title': 'Downloads', 'subtitle': '67 songs'},
    {'icon': 'history', 'title': 'Recently Played', 'subtitle': '100 songs'},
  ];

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
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

  Widget _buildLibraryItem(IconData icon, String title, String subtitle) {
    return Card(
      color: const Color(0xFF2A2A2A),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Example: you can later update the UI dynamically here
          // setState(() { ... });
        },
      ),
    );
  }
}
