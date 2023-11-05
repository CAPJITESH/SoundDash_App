import 'package:SoundDash/services/database.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  final Function(dynamic) onClose;
  const FavoritePage({super.key, required this.onClose});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press event
        widget.onClose('Return');

        // Return false to prevent the default back button behavior
        return false;
      },
      child: Scaffold(
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
            ),),
            StreamBuilder<QuerySnapshot>(
              stream: DatabaseService().getFavStream(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No history data available.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<Map<String, dynamic>> historyDataList =
                        snapshot.data!.docs.map((QueryDocumentSnapshot historyDoc) {
                      Map<String, dynamic> data =
                          historyDoc.data() as Map<String, dynamic>;
                      Map<String, dynamic> songData =
                          data['songData'] as Map<String, dynamic>;

                      return songData;
                    }).toList();

                    QueryDocumentSnapshot historyDoc = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        historyDoc.data() as Map<String, dynamic>;

                    return InkWell(
                      onTap: () {
                        selectedSongDataProvider.startPlaylistSongs(
                            historyDataList, index);
                      },
                      child: ListTile(
                        leading: Image.network(data['image']),
                        title: Text(data['title'], maxLines: 2, overflow: TextOverflow.ellipsis,),
                        subtitle: Text(data['artist'],maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
