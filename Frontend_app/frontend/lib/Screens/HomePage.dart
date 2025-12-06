import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/AllSongsPage.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/SongPlayerPage.dart';
import 'package:frontend/adminPanel/AddMusicForm.dart';
import 'package:frontend/handleApi/ApiService%20.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  List<dynamic> topSongs = [];
  bool isLoading = true;



  void loadSongs() async {
    topSongs = await ApiService.fetchAllMusic();
    setState(() {
      isLoading = false;
    });
  }

  // Dynamic data for future updates

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

  List<Map<String, dynamic>> topCharts = [
    {'title': '1990s Hindi', 'color': Colors.orange},
    {'title': 'Most Streamed\nLove Songs', 'color': Colors.green},
    {'title': 'Hindi 1980s', 'color': Colors.purple},
  ];
  bool isDarkTheme = true;

  @override
  void initState() {
    super.initState();

    super.initState();
    loadSongs();

    // Auto-slide each 3 seconds
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


  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Music", style: TextStyle(fontWeight: FontWeight.bold)),

        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),

            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMusicForm()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBannerSlider(),
            const SizedBox(height: 20),
            _buildRecentlyPlayed(),
            const SizedBox(height: 20),
            _buildTopCharts(),
          ],
        ),
      ),
      backgroundColor: isDarkTheme ? const Color(0xFF121212) : Colors.white,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue],
              ),
            ),
            child: Column(
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
          const Divider(color: Colors.grey),
          _buildDrawerItem(Icons.settings, 'Settings'),
          _buildDrawerItem(Icons.help, 'Help & Feedback'),
        ],
      ),
    );
  }
  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {},
    );
  }

  Widget buildBannerSlider() {
    return Column(
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

        /// Page Indicator Dots
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


  Widget _buildRecentlyPlayed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recently Played',
            style: TextStyle(
              color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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

  Widget _buildTopCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Charts',
                style: TextStyle(
                  color: Colors.white,
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
                      builder: (context) => SongPlayerPage(
                        image: song["Image"],
                        title: song["Title"],
                        singer: song["Singer"],
                        audioUrl: song["Song"], // backend MP3 URL
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

  // Widget _buildChartCard(String title, Color color) {
  //   return Container(
  //     width: 160,
  //     margin: const EdgeInsets.symmetric(horizontal: 4),
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Text(
  //           title,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
}
