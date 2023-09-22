import 'package:SoundDash/Auth/auth.dart';
import 'package:SoundDash/api/song_api.dart';
import 'package:SoundDash/cards/album_card_home.dart';
import 'package:SoundDash/pages/playlist_view.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map<String, dynamic>> fetchApiResponse() async {
    HomeDataFetcher homeInst = HomeDataFetcher();
    // print(homeInst.fetchData());

    return await homeInst.fetchData();
  }

  void updateSongData(Map<String, dynamic> data) {
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);
    selectedSongDataProvider.updateSelectedSongData(data);
    // print(data);
  }

  bool _isFullScreenVisible = false;
  Map<String, dynamic> AlbumData = {};

  void _handleCardPressed(Map<String, dynamic> pressedData) {
    setState(() {
      _isFullScreenVisible = true;
      AlbumData = pressedData;
    });
  }

  String nameOfUser = FirebaseAuth.instance.currentUser?.displayName ?? '';
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 70, 1, 50),
                      Color.fromARGB(255, 50, 1, 40),
                      Color.fromARGB(255, 10, 1, 20),
                      Colors.black.withOpacity(1),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: auth.HandleGoogleSignOut,
                        child: const Text('SignOut')),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.white,
                      child: const Text(
                        "Hey, How it's Going",
                        // textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 219, 172, 255)),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Let's Vibe $nameOfUser",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 234, 234, 234)),
                      ),
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: fetchApiResponse(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final responseMap = snapshot.data!;

                          return Column(
                            children: responseMap.entries.map((entry) {
                              String sectionTitle = entry.key;
                              List<dynamic> sectionData = entry.value;

                              return Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        EdgeInsets.only(top: 25, bottom: 8),
                                    child: Text(
                                      sectionTitle,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 219, 172, 255),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 155,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sectionData.length,
                                      itemBuilder: (context, index) {
                                        final sectionItemData =
                                            sectionData[index];

                                        return AlbumCard(
                                          onCardPressed: _handleCardPressed,
                                          albumData: sectionItemData,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    // SizedBox(
                    //   height: 100,
                    // ),
                  ],
                ),
              ),
            ),
            if (_isFullScreenVisible)
              PlaylistView(
                albumData: AlbumData,
                onClose: (returnValue) {
                  setState(() {
                    _isFullScreenVisible = false;
                    // Do something with the return value if needed
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
