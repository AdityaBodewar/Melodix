import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/SongPlayerPage.dart';
import 'package:frontend/handleApi/ApiService%20.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  State<Searchpage> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<Searchpage> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  List<dynamic> searchResults = [];

  Timer? _debounce;


  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isNotEmpty) {
        _searchSong(query);
      } else {
        setState(() => searchResults = []);
      }
    });
  }

  Future<void> _searchSong(String query) async {
    setState(() {
      isLoading = true;
      searchResults = [];
    });

    final results = await ApiService.searchMusic(query);

    setState(() {
      isLoading = false;
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,

                      onChanged: _onSearchChanged,

                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      onTap: () => print("Search field clicked"),

                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search for songs, artists, albums...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //  Loading
            if (isLoading)
              const Center(child: CircularProgressIndicator())

            // 🎵 Default message
            else if (searchResults.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Search for your favorite music',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              )

            //  Search Results
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final song = searchResults[index];

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song["Image"],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song["Title"],
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        song["Singer"] ?? "",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongPlayerPage(
                              songs: searchResults,
                              currentIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
