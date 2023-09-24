import 'package:SoundDash/services/selected_song_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const FavouriteCard({super.key, required this.data});

  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {

  @override
  Widget build(BuildContext context) {
  final selectedSongDataProvider = Provider.of<SelectedSongDataProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.2),
      ),
      child: Center(
        child: InkWell(
          onTap: () {
            selectedSongDataProvider.updateSelectedSongData(widget.data['songData']);
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Adjust the radius as needed
              child: Image.network(
                widget.data['image'],
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              widget.data['title'],
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              widget.data['artist'],
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
