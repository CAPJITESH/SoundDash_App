import 'package:SoundDash/services/songs_card_options.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayAlbumCard extends StatelessWidget {
  final dynamic songData, playlist;
  final int index;

  const PlayAlbumCard(
      {required this.songData, required this.index, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final songName = songData['name'] as String? ?? '';
    final artistName = songData['primaryArtists'] as String? ?? '';
    final imageLink = songData['image'][2]['link'] as String? ?? '';
    // print(imageLink);
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        selectedSongDataProvider.startPlaylistSongs(playlist, index);
      },
      child: Container(
        // height: 100,
        // color: Color.fromARGB(255, 26, 4, 28),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Card(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            child: ListTile(
              leading: Image.network(
                imageLink,
                width: 100,
                height: 100,
              ),
              title: Text(
                songName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(
                artistName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: SongsOptions(songData: songData),
            ),
          ),
        ),
      ),
    );
  }
}
