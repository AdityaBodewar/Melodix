import 'package:flutter/material.dart';
import 'package:frontend/AboutUsPage.dart';
import 'package:frontend/HelpSupportPage.dart';
import 'package:frontend/theme_controller.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profilepage> {
  String name = 'Music Lover';
  String email = 'musiclover@example.com';

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              name,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              email,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            _buildProfileOption(Icons.edit, 'Edit Profile', _showEditDialog),
            _buildProfileOption(Icons.notifications, 'Notifications', () {}),
            _buildProfileOption(Icons.privacy_tip, 'Privacy', () {}),
            _buildProfileOption(Icons.language, 'Language', () {}),

            // Theme toggle
            _buildProfileOption(Icons.dark_mode, 'Theme', () {
              ThemeController.toggleTheme();
            }),

            _buildProfileOption(Icons.help, 'Help & Support', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage()),
              );

            }),
            _buildProfileOption(Icons.info, 'About', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsPage()),
              );
            }),
            _buildProfileOption(Icons.logout, 'Logout', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      IconData icon, String title, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final subtitleColor = isDark ? Colors.grey : Colors.black54;

    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      trailing: Icon(Icons.chevron_right, color: subtitleColor),
      onTap: onTap,
    );
  }

  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
