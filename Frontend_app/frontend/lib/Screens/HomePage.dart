import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/AboutUsPage.dart';
import 'package:frontend/AlbumsPage.dart';
import 'package:frontend/AllSongsPage.dart';
import 'package:frontend/ArtistSongsPage.dart';
import 'package:frontend/DownloadsPage.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/Registerpage.dart';
import 'package:frontend/Screens/ProfilePage.dart';
import 'package:frontend/SettingsPage.dart';
import 'package:frontend/SongPlayerPage.dart';
import 'package:frontend/handleApi/ApiService%20.dart';
import 'package:frontend/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;

  List<dynamic> topSongs = [];
  List<dynamic> artists = [];
  List<dynamic> recommendedSongs = [];

  bool isLoading = true;
  bool artistLoading = true;
  bool _hasLoadedOnce = false;

  DateTime? _lastLoadTime;
  static const _cacheValidDuration = Duration(minutes: 10);

  @override
  bool get wantKeepAlive => true;

  List<Map<String, String>> banners = [
    {"image": "assets/images/arijit4.jpeg"},
    // {"image": "assets/images/shreyaa.jpeg.jpeg"},
    // {"image": "assets/images/kishorekumar.jpeg"},
    // {"image": "assets/images/arijit2.jpeg"},
    {"image": "assets/images/ladysinger.jpeg"},
    {"image": "assets/images/uditnarayan.jpeg"},
    // {"image": "assets/images/himesh.jpeg"},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _startBannerTimer();
  }

  void _loadInitialData() {
    if (!_hasLoadedOnce) {
      loadSongs();
      loadArtists();
    }
  }

  Future<void> loadSongs({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _hasLoadedOnce &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration) {
      return;
    }


    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    topSongs.clear();
    final newSongs = await ApiService.fetchAllMusic();

    if (mounted) {
      setState(() {
        topSongs = newSongs;
        recommendedSongs = List.from(newSongs)..shuffle();
        recommendedSongs = recommendedSongs.take(6).toList();
        isLoading = false;
        _hasLoadedOnce = true;
        _lastLoadTime = DateTime.now();
      });
    }
  }

  Future<void> loadArtists({bool forceRefresh = false}) async {
    if (!forceRefresh && artists.isNotEmpty) {
      return;
    }


    if (mounted) {
      setState(() {
        artistLoading = true;
      });
    }

    final data = await ApiService.fetchAllArtists();

    if (mounted) {
      setState(() {
        artists = data;
        artistLoading = false;
      });
    }
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients && mounted) {
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
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

                  if (token != null && token.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Profilepage()),
                    );
                    return;
                  }

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
                          Divider(height: 1, color: isDark ? Colors.white24 : Colors.black12),
                          ListTile(
                            leading: Icon(Icons.login, color: isDark ? Colors.white : Colors.black87),
                            title: Text("Login", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.app_registration, color: isDark ? Colors.white : Colors.black87),
                            title: Text("Register", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.close, color: Colors.redAccent),
                            title: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
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
          await loadSongs(forceRefresh: true);
          await loadArtists(forceRefresh: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                colors: isDark ? [Colors.blue, Colors.lightBlue] : [Colors.blue.shade300, Colors.lightBlueAccent],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.music_note, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text('Music App', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home'),
          _buildDrawerItem(Icons.favorite, 'Favorites'),
          _buildDrawerItem(Icons.album, 'Albums'),
          _buildDrawerItem(Icons.download_sharp, 'DownloadSong'),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
        } else if (title == 'Home') {
          Navigator.pop(context);
          MainScreen.changeTab?.call(0);
        } else if (title == 'About us') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
        } else if(title == 'Albums'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumsPage()));
        } else if(title == 'DownloadSong'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DownloadsPage()));
        }
      },
    );
  }

  Widget buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentBanner = index),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(image: AssetImage(banners[index]["image"]!), fit: BoxFit.cover),
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
                color: _currentBanner == index ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayed(Color textColor, bool isDark) {
    if (recommendedSongs.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Recommended', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: recommendedSongs.length,
            itemBuilder: (context, index) {
              final song = recommendedSongs[index];
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SongPlayerPage(songs: recommendedSongs, currentIndex: index))),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(image: NetworkImage(song["Image"]), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(song["Title"], style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
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
              Text('Top Charts', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllSongsPage(songs: topSongs))),
                child: const Text('View All', style: TextStyle(color: Colors.blue)),
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SongPlayerPage(songs: topSongs, currentIndex: index))),
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
        image: DecorationImage(image: NetworkImage(song["Image"]), fit: BoxFit.cover),
      ),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.4),
        child: Text(song["Title"], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildArtistAlbum(Color textColor) {
    if (artistLoading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Artists', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 20)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArtistSongsPage(artist: artist))),
                child: _buildArtistCard(artist),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistCard(dynamic artist) {
    final String imageUrl = artist["Image"] ?? "";
    final String name = artist["Fullname"] ?? "Unknown Artist";
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}