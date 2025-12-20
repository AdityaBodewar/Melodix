import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
    final theme = Theme.of(context);

    final bgColor = theme.scaffoldBackgroundColor;
    final primaryText = theme.textTheme.bodyLarge?.color;
    final secondaryText = theme.textTheme.bodyMedium?.color;
    final cardColor = theme.cardColor;
    final accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _faqTile(
            context,
            "How to download songs?",
            "Open a song → tap the 3-dot menu → select Download.",
          ),

          _faqTile(
            context,
            "Why is the music not playing?",
            "Check your internet, restart the app, or try reinstalling.",
          ),

          _faqTile(
            context,
            "How to change the theme?",
            "Go to Settings → Theme → Light / Dark / System.",
          ),

          _faqTile(
            context,
            "How to create Album?",
            "Open My Library → Album → Click + sign & save album name -> hold the folder -> select song -> add song.",
          ),

          const SizedBox(height: 25),

          Text(
            "Contact Us",
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.email, color: accent),
              title: Text(
                "Email Support",
                style: TextStyle(color: primaryText),
              ),
              subtitle: Text(
                "Get help directly from our team",
                style: TextStyle(color: secondaryText),
              ),
              trailing: Icon(Icons.chevron_right, color: secondaryText),
              onTap: _openEmail,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.redAccent),
              title: Text(
                "Report a Problem",
                style: TextStyle(color: primaryText),
              ),
              subtitle: Text(
                "Facing an issue? Tell us.",
                style: TextStyle(color: secondaryText),
              ),
              trailing: Icon(Icons.chevron_right, color: secondaryText),
              onTap: () => _showReportDialog(context),
            ),
          ),

          const SizedBox(height: 25),

          Center(
            child: Column(
              children: [
                Text(
                  "Melodix Music App",
                  style: TextStyle(color: primaryText, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(color: secondaryText, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqTile(BuildContext context, String title, String description) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        collapsedIconColor: theme.iconTheme.color,
        iconColor: theme.iconTheme.color,
        title: Text(
          title,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              description,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Report a Problem",
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: "Describe the issue...",
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Problem submitted! Our team will review it.",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
