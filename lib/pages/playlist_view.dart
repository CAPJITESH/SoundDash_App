import 'package:SoundDash/api/song_api.dart';
import 'package:SoundDash/cards/play_album_card.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';

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
  void initState() {
    extractColor();
    super.initState();
  }

  Color extracted_color = Colors.black;

  Future<void> extractColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            NetworkImage(widget.albumData['image'] as String),
            size: const Size(200, 200));

    setState(() {
      extracted_color = paletteGenerator.dominantColor!.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    String artistNames = '';

    try {
      if (widget.albumData['more_info'] != null) {
        if (widget.albumData['more_info']['artistMap'] != null) {
          widget.albumData['more_info']['artistMap']['artists'].forEach((item) {
            artistNames += item['name'];
          });
        } else {
          artistNames = widget.albumData['subtitle'];
        }
      }
    } catch (e) {
      artistNames = " ";
    }
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);

    Future<Map<String, dynamic>> fetchData() async {
      switch (widget.albumData['type']) {
        case 'playlist':
          return Api.getPlaylist(widget.albumData['id']);
        case 'album':
          return Api.getAlbum(widget.albumData['perma_url']);

        default:
          final url = widget.albumData['perma_url'].split('/').last;
          return Api.otherData(url, widget.albumData['type'],"");
      }
    }

    return WillPopScope(
      onWillPop: () async {
        widget.onClose('Return');
        return false;
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  extracted_color,
                  Color.fromARGB(255, 28, 15, 25),
                  const Color.fromARGB(255, 10, 1, 20),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.albumData['title'],
                    style: const TextStyle(fontSize: 25),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    artistNames,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final responseMap = snapshot.data!;
                        final songResults = responseMap['data']['songs'];
                        print(songResults);
                        return Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                selectedSongDataProvider.startPlaylistSongs(
                                    songResults, 0);
                              },
                              icon: const Icon(Icons.play_circle),
                              iconSize: 50,
                            ),
                            Column(
                              children: List.generate(
                                songResults.length,
                                (index) {
                                  final songData = songResults[index];

                                  return Column(
                                    children: [
                                      PlayAlbumCard(
                                        index: index,
                                        songData: songData,
                                        playlist: songResults,
                                      ),
                                      if (index < songResults.length - 1)
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
