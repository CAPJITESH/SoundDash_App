import 'package:SoundDash/pages/fav_page.dart';
import 'package:SoundDash/pages/history_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    String emailOfUser = FirebaseAuth.instance.currentUser?.email ?? '';
    String nameOfUser = FirebaseAuth.instance.currentUser?.displayName ?? '';

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
                SizedBox(height: 50), // Add some space at the top
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40, // Adjust the size as needed
                        child: Icon(
                          Icons.person_2, // Add your user icon here
                          size: 55, // Adjust the size as needed
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10), // Add some space
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameOfUser, // Add user name
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            emailOfUser, // Add user email
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Playlists',
                  style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.left,
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  // Color for the container
                  child: ListTile(
                    title: Text(
                      "History",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      ScreenName('History');
                      toggleScreen();
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  // Color for the container
                  child: ListTile(
                    title: Text(
                      "Favorites",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      ScreenName('Favorites');
                      toggleScreen();
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isPlaylistVisible)
            if (opened == 'History')
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
