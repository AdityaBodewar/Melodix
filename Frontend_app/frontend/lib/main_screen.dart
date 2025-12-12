import 'package:flutter/material.dart';
import 'package:frontend/NotLoggedInPage.dart';
import 'package:frontend/OfflinePlayerPage.dart';
import 'package:frontend/Screens/HomePage.dart';
import 'package:frontend/Screens/MyLibrary.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/Screens/SearchPage.dart';
import 'package:frontend/MusicController.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/SongPlayerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // Listen to online/offline player state
    MusicController.player.onPlayerStateChanged.listen((state) {
      setState(() {
        MusicController.isPlaying = (state == PlayerState.playing);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed; // <-- ADD THIS

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();

        if (lastPressed == null ||
            now.difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = now;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Press back again to exit"),
              duration: Duration(seconds: 2),
            ),
          );

          return false; // DO NOT EXIT
        }

        return true; //  EXIT APP
      },

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _screens[_currentIndex],
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: _buildNowPlayingBar(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final unselected = isDark ? Colors.grey : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,

        //  Main Logic For Restricting Pages
        onTap: (index) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("token");

          // User is NOT logged in & trying to open My Library or Profile
          if ((index == 2 || index == 3) && (token == null || token.isEmpty)) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotLoggedInPage()),
            );
            return;
          }

          // Otherwise allow navigation
          setState(() => _currentIndex = index);
        },

        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        selectedItemColor: Colors.blue,
        unselectedItemColor: unselected,
        selectedFontSize: 12,
        unselectedFontSize: 12,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'My Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }


  Widget _buildNowPlayingBar() {
    if (MusicController.title == null) {
      return SizedBox();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final darkGradient = LinearGradient(
      colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
    );

    final lightGradient = LinearGradient(
      colors: [Color(0xFFEFEFEF), Color(0xFFDADADA)],
    );

    return GestureDetector(
      onTap: () {
        if (MusicController.isOffline == true) {
          // open offline player page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OfflinePlayerPage(
                title: MusicController.title!,
                singer: MusicController.singer!,
                image: MusicController.image!,
                filePath: MusicController.localFilePath!,
              ),
            ),
          );
        } else {
          // open online player page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SongPlayerPage(
                songs: MusicController.currentList ?? [],
                currentIndex: MusicController.currentIndex ?? 0,
              ),
            ),
          );
        }
      },

      child: Container(
        height: 65,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: isDark ? darkGradient : lightGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.grey.shade300,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [
            // SONG IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                MusicController.image!,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 10),

            // TITLE + ARTIST
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MusicController.title ?? "",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
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
                color: isDark ? Colors.white : Colors.black,
                size: 30,
              ),
              onPressed: () async {
                if (MusicController.isOffline == true) {
                  // offline control
                  if (MusicController.isPlaying) {
                    await MusicController.player.pause();
                  } else {
                    await MusicController.player.resume();
                  }
                  MusicController.isPlaying = !MusicController.isPlaying;
                } else {
                  // online control
                  MusicController.togglePlayPause();
                }
                setState(() {});
              },
            ),

            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
