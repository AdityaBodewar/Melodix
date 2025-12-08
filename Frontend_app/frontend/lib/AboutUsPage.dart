import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("About Us"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "MusicVibe – Your Personal Music World",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "MusicVibe is a modern and fast music streaming application "
                    "designed to provide a smooth, high-quality, and user-friendly "
                    "listening experience. Our goal is to make music more enjoyable "
                    "and easily accessible for everyone.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 20),

              const Text(
                "Our Mission",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "We believe music is not just entertainment, but emotion. "
                    "That's why we created MusicVibe with a simple interface, "
                    "intelligent features, and seamless playback to enhance your "
                    "music experience.",
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 20),

              const Text(
                "What We Offer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "• High-quality music streaming\n"
                    "• Offline downloads\n"
                    "• Personalized playlists\n"
                    "• Clean and beautiful UI\n"
                    "• Fast search & smooth playback\n"
                    "• Regular updates",
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 20),

              const Text(
                "Contact Us",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Email: support@musicvibe.app\n"
                    "Instagram: @musicvibe\n"
                    "Website: www.musicvibe.app",
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Thank you for using MusicVibe! 💙",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
