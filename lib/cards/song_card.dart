import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final Map<String, dynamic> songData;
  final Function(Map<String, dynamic>) onCardPressed;

  const SongCard({required this.songData, required this.onCardPressed});

  @override
  Widget build(BuildContext context) {
    final songName = songData['name'];
    final artistName = songData['primaryArtists'];

    return Container(
      color: const Color.fromARGB(255, 36, 13, 65).withOpacity(0),
      padding: EdgeInsets.all(5),
      width: 130,
      child: InkWell(
        onTap: () {
          onCardPressed(songData);
        },
        child: Container(
          child: Column(
            children: [
              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(songData['image'][2]['link']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  songName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                artistName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
