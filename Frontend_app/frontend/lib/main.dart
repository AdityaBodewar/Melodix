import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Screens
import 'Screens/HomePage.dart';
import 'Screens/SearchPage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/MyLibrary.dart';
import 'main_screen.dart';

// Theme Controller
import 'theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status Bar Design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await ThemeController.loadTheme();


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

          //  Whole App Theme Controller
          themeMode: mode,

          //  LIGHT THEME
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

          //  DARK THEME
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

          // Starting Screen
          home: const MainScreen(),

          // App Routes
          routes: {
            '/home': (context) => HomePage(),
            '/search': (context) => Searchpage(),
            '/library': (context) => Mylibrary(),
            '/profile': (context) => Profilepage(),
          },
        );
      },
    );
  }
}
