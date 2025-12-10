import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage.dart';
import 'package:frontend/Screens/MyLibrary.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/Screens/SearchPage.dart';
import 'package:frontend/MusicController.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/SongPlayerPage.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static Function(int)? changeTab;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    Searchpage(),
    Mylibrary(),
    Profilepage(),
  ];

  @override
  void initState() {
    super.initState();
    MainScreen.changeTab = (int index) {
      setState(() {
        _currentIndex = index;
      });
    };

    //  IMPORTANT: Listen to MusicController updates
    MusicController.player.onPlayerStateChanged.listen((state) {
      setState(() {
        MusicController.isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _screens[_currentIndex],   //  MAIN SCREEN at bottom

          //  NOW PLAYING BAR at bottom ABOVE NAV BAR
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,  // bottom nav ki height + margin
            child: _buildNowPlayingBar(),
          ),

          //  BOTTOM NAV BAR at bottom-most
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),


    );
  }

  Widget _buildBottomNavigationBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final unselected = isDark ? Colors.grey : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        selectedItemColor: Colors.blue,
        unselectedItemColor: unselected,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'My Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNowPlayingBar() {
    if (MusicController.title == null) {
      return SizedBox();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🌙 Dark Mode Colors
    final darkGradient = const LinearGradient(
      colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
    );
    final darkText = Colors.white;
    final darkIcon = Colors.white;

    // ☀️ Light Mode Colors
    final lightGradient = const LinearGradient(
      colors: [Color(0xFFEFEFEF), Color(0xFFDADADA)],
    );
    final lightText = Colors.black;
    final lightIcon = Colors.black87;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SongPlayerPage(
              songs: MusicController.currentList ?? [],
              currentIndex: MusicController.currentIndex ?? 0,
            ),
          ),
        );
      },
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: isDark ? darkGradient : lightGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // COVER IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                MusicController.image!,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 10),

            // TITLE + ARTIST
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MusicController.title ?? "",
                    style: TextStyle(
                      color: isDark ? darkText : lightText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    MusicController.singer ?? "",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // PLAY / PAUSE BUTTON
            IconButton(
              icon: Icon(
                MusicController.isPlaying ? Icons.pause : Icons.play_arrow,
                color: isDark ? darkIcon : lightIcon,
                size: 30,
              ),
              onPressed: () {
                MusicController.togglePlayPause();
                setState(() {});
              },
            ),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }


}
