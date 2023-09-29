import 'package:SoundDash/api/song_api.dart';
import 'package:SoundDash/services/songs_card_options.dart';
import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchSongCard extends StatefulWidget {
  final dynamic songData;
  final Function(Map<String, dynamic>) onCardPressed;

  const SearchSongCard({required this.songData, required this.onCardPressed});

  @override
  State<SearchSongCard> createState() => _SearchSongCardState();
}

class _SearchSongCardState extends State<SearchSongCard> {
  Widget trailingWidget = const SizedBox();
  Map<String, dynamic> songDetailsData = {};

  Future<void> _fetchSongDetails() async {
    songDetailsData = await Api.getSongDetails(widget.songData['id']);
    setState(() {
      trailingWidget = SongsOptions(songData: songDetailsData['data'][0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final songName = widget.songData['title'] as String? ?? '';
    final artistName = widget.songData['subtitle'] as String? ?? '';
    final imageLink = widget.songData['image'] as String? ?? '';
    final type = widget.songData['type'] ?? "album";
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);

    if (type == 'song') {
      _fetchSongDetails();
    } else {
      trailingWidget = const SizedBox();
    }

    return InkWell(
      onTap: () async {
        if (type == 'song') {
          // print(songDetailsData);
          selectedSongDataProvider
              .updateSelectedSongData(songDetailsData['data'][0]);
        } else {
          widget.onCardPressed(widget.songData);
        }
        // selectedSongDataProvider.updateSelectedSongData(songData);
      },
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
        trailing: trailingWidget, // Use the trailing widget here
      ),
    );
  }
}
