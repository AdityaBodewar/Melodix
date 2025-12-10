import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  // 📩 Open Email App for Support
  Future<void> _openEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@melodixapp.com',
      query: 'subject=Melodix App Support&body=Describe your issue here:',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Help & Support"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ❓ Frequently Asked Questions
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _faqTile("How to download songs?",
              "Open a song → tap the 3-dot menu → select Download."),

          _faqTile("Why is the music not playing?",
              "Check your internet, restart the app, or try reinstalling."),

          _faqTile("How to change the theme?",
              "Go to Settings → Theme → Light / Dark / System."),

          _faqTile("How to create playlists?",
              "Open My Library → Playlists → Create new playlist."),

          const SizedBox(height: 25),

          // 📞 Contact Section
          const Text(
            "Contact Us",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text("Email Support", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Get help directly from our team",
                  style: TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _openEmail,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.redAccent),
              title: const Text("Report a Problem", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Facing an issue? Tell us.",
                  style: TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                _showReportDialog(context);
              },
            ),
          ),

          const SizedBox(height: 25),

          // ℹ️ App Info
          Center(
            child: Column(
              children: const [
                Text("Melodix Music App",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 5),
                Text("Version 1.0.0",
                    style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // FAQ UI Widget
  Widget _faqTile(String title, String description) {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: ExpansionTile(
        collapsedIconColor: Colors.white70,
        iconColor: Colors.white,
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(description,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          )
        ],
      ),
    );
  }

  // Report Problem Dialog
  void _showReportDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Report a Problem", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Describe the issue...",
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Submit"),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Problem submitted! Our team will review it.")),
              );
            },
          )
        ],
      ),
    );
  }
}
