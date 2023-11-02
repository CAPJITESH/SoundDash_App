import 'package:SoundDash/pages/fav_page.dart';
import 'package:SoundDash/pages/history_view.dart';
import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  bool isPlaylistVisible = false;
  String opened = "";

  void ScreenName(String name) {
    setState(() {
      opened = name;
    });
  }

  void toggleScreen() {
    setState(() {
      isPlaylistVisible = !isPlaylistVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 70, 1, 50),
                  const Color.fromARGB(255, 50, 1, 40),
                  const Color.fromARGB(255, 10, 1, 20),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                ListTile(
                  // tileColor: Colors.amber,
                  title: Text("History"),
                  onTap: () {
                    // print('pressedddddddddddddddddddddd');
                    ScreenName('History');
                    toggleScreen();
                  },
                ),
                ListTile(
                  // tileColor: Colors.amber,
                  title: Text("Favorites"),
                  onTap: () {
                    // print('pressedddddddddddddddddddddd');
                    ScreenName('Favorites');
                    toggleScreen();
                  },
                )
              ],
            ),
          ),
          if (isPlaylistVisible)

            if(opened == 'History')
              History(
                onClose: (returnValue) {
                  toggleScreen();
                },
              )
            else
              FavoritePage(
                onClose: (returnValue) {
                  toggleScreen();
                },
              ) 
        ],
      ),
    );
  }
}
