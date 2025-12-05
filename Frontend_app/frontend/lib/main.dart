import 'package:flutter/material.dart';
import 'AddMusicForm.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'ProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/search': (context) => SearchPage(),
        '/profile': (context) => ProfilePage(),

      },
    );
  }
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),

      body: Center(
        child: ElevatedButton(
          child: const Text("Add Songs"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMusicForm()),
            );
          },
        ),
      ),
    );
  }
}