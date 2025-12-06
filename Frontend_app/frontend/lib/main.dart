import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Screens
import 'Screens/HomePage.dart';
import 'Screens/SearchPage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/MyLibrary.dart';
import 'adminPanel/AddMusicForm.dart';
import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Status Bar Design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // modern transparent bar
      statusBarIconBrightness: Brightness.light, // white icons
      systemNavigationBarColor: Color(0xFF121212), // bottom bar dark
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melodix App',
      debugShowCheckedModeBanner: false,

      // ----------- Theme -----------
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),

      home: const MainScreen(),

      // ----------- Routing -----------
      // initialRoute: '/',
      // routes: {
      //
      //   '/home' : (Context) => HomePage(),
      //   '/search': (context) =>  SearchPage(),
      //   '/library': (context) =>  MyLibrary(),
      //   '/profile': (context) =>  ProfilePage(),
      //
      // },

      routes: {
        '/home': (context) =>  HomePage(),
        '/search': (context) =>  SearchPage(),
        '/library': (context) =>  LibraryPage(),
        '/profile': (context) =>  ProfilePage(),
      },
    );
  }
}
