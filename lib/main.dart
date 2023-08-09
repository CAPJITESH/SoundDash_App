import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:SoundDash/pages/bottom_navbar.dart';
import 'package:provider/provider.dart';

// import 'package:sound_dash/pages/search.dart';


Future<void> main() async {
runApp(
    ChangeNotifierProvider(
      create: (context) => SelectedSongDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: Colors.grey[600],
        ),
      ),
      home: Navbar(),
    );
  }
}