// only changed parts, full file ready to paste

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/AboutUsPage.dart';
import 'package:frontend/AllSongsPage.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/Registerpage.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/SettingsPage.dart';
import 'package:frontend/SongPlayerPage.dart';
import 'package:frontend/adminPanel/AddMusicForm.dart';
import 'package:frontend/handleApi/ApiService%20.dart';
import 'package:frontend/adminPanel/adminloginpage.dart';
import 'package:frontend/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  List<dynamic> topSongs = [];
  bool isLoading = true;
  Future<void> loadSongs() async {
    setState(() {
      isLoading = true;
    });

    // 🔥 STEP 1: Clear previous songs to avoid duplicates
    topSongs.clear();

    // 🔥 STEP 2: Fetch fresh updated list
    final newSongs = await ApiService.fetchAllMusic();

    // 🔥 STEP 3: Replace list
    topSongs = newSongs;

    setState(() {
      isLoading = false;
    });
  }



  List<Map<String, String>> banners = [
    {"image": "assets/images/arijit_img.jpeg"},
    {"image": "assets/images/shreya_img.jpeg"},
    {"image": "assets/images/udit_img.jpeg"},
  ];

  List<Map<String, String>> recentlyPlayed = [
    {'title': 'Ae Kash Ke Hum', 'artist': 'Kumar Sanu'},
    {'title': 'Jitni Dafa', 'artist': 'Armaan Malik'},
    {'title': 'Zara Sa', 'artist': 'KK'},
  ];

  @override
  void initState() {
    super.initState();
    loadSongs();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        _currentBanner++;
        if (_currentBanner == banners.length) {
          _currentBanner = 0;
        }
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Music", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token = prefs.getString("token");

                  final isDark = Theme.of(context).brightness == Brightness.dark;

                  // 👉 IF USER IS LOGGED IN → GO TO PROFILE PAGE
                  if (token != null && token.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Profilepage()),
                    );
                    return;
                  }

                  // 👉 IF NOT LOGGED IN → SHOW LOGIN / REGISTER OPTIONS
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
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadSongs();      // 🔥 reload songs
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // 🔥 allow scroll & pull even if short
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBannerSlider(),
              const SizedBox(height: 20),
              _buildRecentlyPlayed(textColor, isDark),
              const SizedBox(height: 20),
              _buildTopCharts(textColor),
              const SizedBox(height: 40),
              _buildArtistAlbum(textColor),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer
  Widget _buildDrawer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.blue, Colors.lightBlue]
                    : [Colors.blue.shade300, Colors.lightBlueAccent],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.music_note, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Music App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home'),
          _buildDrawerItem(Icons.favorite, 'Favorites'),
          _buildDrawerItem(Icons.playlist_play, 'Playlists'),
          _buildDrawerItem(Icons.library_music, 'Jio Tunes'),
          const Divider(),
          _buildDrawerItem(Icons.settings, 'Settings'),
          _buildDrawerItem(Icons.info, 'About us'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: () {
        if (title == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        } else if (title == 'Home') {
          Navigator.pop(context);
          MainScreen.changeTab?.call(0);
        } else if (title == 'About us') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUsPage()),
          );
        }
      },
    );
  }

  // Banner slider same as before...
  Widget buildBannerSlider() { /* unchanged from your version */ return Column(
    children: [
      SizedBox(
        height: 190,
        child: PageView.builder(
          controller: _bannerController,
          itemCount: banners.length,
          onPageChanged: (index) {
            setState(() {
              _currentBanner = index;
            });
          },
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(banners[index]["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(banners.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: _currentBanner == index ? 18 : 6,
            decoration: BoxDecoration(
              color: _currentBanner == index
                  ? Colors.white
                  : Colors.white54,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    ],
  );
  }

  Widget _buildRecentlyPlayed(Color textColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recently Played',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: recentlyPlayed.length,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: const Center(
                        child: Icon(Icons.music_note, size: 50, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recentlyPlayed[index]['title']!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopCharts(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Charts',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSongsPage(songs: topSongs),
                    ),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: topSongs.length,
            itemBuilder: (context, index) {
              final song = topSongs[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongPlayerPage(
                        songs: topSongs,
                        currentIndex: index,
                      ),
                    ),
                  );
                },
                child: _buildSongCard(song),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSongCard(dynamic song) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(song["Image"]),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.4),
        child: Text(
          song["Title"],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildArtistAlbum(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Artists',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSongsPage(songs: topSongs),
                    ),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: topSongs.length,
            itemBuilder: (context, index) {
              final song = topSongs[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongPlayerPage(
                        songs: topSongs,
                        currentIndex: index,
                      ),
                    ),
                  );
                },
                child: _buildArtistCard(song),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildArtistCard(dynamic song) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              song["Image"],
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song["Singer"],
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
