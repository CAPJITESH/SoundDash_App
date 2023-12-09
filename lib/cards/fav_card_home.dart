import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:SoundDash/services/formatter.dart';
import 'package:provider/provider.dart';

class FavouriteCard extends StatefulWidget {
  
  final List<dynamic> favPlaylist;
  final int index;
  const FavouriteCard({super.key,required this.favPlaylist, required this.index});

  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  @override
  Widget build(BuildContext context) {
    final selectedSongDataProvider =
        Provider.of<SelectedSongDataProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.2),
      ),
      child: Center(
        child: InkWell(
          onTap: () {
            selectedSongDataProvider
                .startPlaylistSongs(widget.favPlaylist, widget.index);
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Adjust the radius as needed
              child: Image.network(
                widget.favPlaylist[widget.index]['image'][2]['link'],
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              htmlFormatter.removeHtmlTags(widget.favPlaylist[widget.index]['name']),
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              widget.favPlaylist[widget.index]['primaryArtists'],
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
