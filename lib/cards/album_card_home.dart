import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final Map<String, dynamic> albumData;
  final Function(Map<String, dynamic>) onCardPressed;

  const AlbumCard({required this.albumData, required this.onCardPressed});

  @override
  Widget build(BuildContext context) {
    final albumName = albumData['title'];
    String artistNames = '';
    try{
    if (albumData['more_info'] != null) {
      if (albumData['more_info']['artistMap'] != null) {
        albumData['more_info']['artistMap']['artists'].forEach((item) {
          artistNames += item['name'];
        });
      } else {
        artistNames = albumData['subtitle'];
      }
    }}
    catch (e) {
      artistNames = " ";
    }
    // print(artistNames);
    return Container(
      color: const Color.fromARGB(255, 36, 13, 65).withOpacity(0),
      padding: EdgeInsets.all(5),
      width: 130,
      child: InkWell(
        onTap: () {
          onCardPressed(albumData);
        },
        child: Column(
          children: [
            Container(
              width: 107,
              height: 106,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(albumData['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                albumName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Text(
              artistNames,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
