import 'package:SoundDash/api/song_api.dart';
import 'package:SoundDash/cards/play_album_card.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistView extends StatefulWidget {
  final Map<String, dynamic> albumData;
  final Function(dynamic) onClose;

  const PlaylistView({Key? key, required this.albumData, required this.onClose})
      : super(key: key);

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    String artistNames = '';

    try{
    if (widget.albumData['more_info'] != null) {
      if (widget.albumData['more_info']['artistMap'] != null) {
        widget.albumData['more_info']['artistMap']['artists'].forEach((item) {
          artistNames += item['name'];
        });
      } else {
        artistNames = widget.albumData['subtitle'];
      }
    }}
    catch (e) {
      artistNames = " ";
    }
    final selectedSongDataProvider = Provider.of<SelectedSongDataProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press event
        widget.onClose('Return');

        // Return false to prevent the default back button behavior
        return false;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
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
            SizedBox(
              height: 40,
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.albumData['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              widget.albumData['title'],
              style: TextStyle(fontSize: 25),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10,),

            Text(
              artistNames,
              style: TextStyle(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: widget.albumData['type'] == 'playlist'
                    ? Api.getPlaylist(widget.albumData['id'])
                    : Api.getAlbum(widget.albumData['perma_url']),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final responseMap = snapshot.data!;
                    final songResults = responseMap['data']['songs'];

                    return Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // print(songResults);
                            selectedSongDataProvider.updateSelectedSongData(songResults);
                          },
                          icon: const Icon(Icons.play_circle),
                          iconSize: 50,
                        ),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              itemCount: songResults.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: Colors.grey,
                                thickness: 1.0,
                              ),
                              itemBuilder: (context, index) {
                                final songData = songResults[index];

                                return PlayAlbumCard(
                                  songData: songData,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
