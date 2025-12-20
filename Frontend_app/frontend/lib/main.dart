import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/Registerpage.dart';

import 'MusicController.dart';
import 'Screens/HomePage.dart';
import 'Screens/SearchPage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/MyLibrary.dart';
import 'main_screen.dart';

import 'theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await ThemeController.loadTheme();
  await MusicController.configureAudioSession();



  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Melodix App',
          debugShowCheckedModeBanner: false,

          themeMode: mode,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          home: const MainScreen(),

          routes: {
            '/home': (context) => HomePage(),
            '/search': (context) => Searchpage(),
            '/library': (context) => Mylibrary(),
            '/profile': (context) => Profilepage(),
            '/login' : (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
          },
        );
      },
    );
  }
}
