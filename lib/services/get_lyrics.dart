import 'package:SoundDash/api/song_api.dart';
import 'package:flutter/material.dart';

class GetLyrics extends StatefulWidget {
  final Map<String, dynamic> songData;
  const GetLyrics({super.key, required this.songData});

  @override
  State<GetLyrics> createState() => _GetLyricsState();
}

class _GetLyricsState extends State<GetLyrics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: Api.getLyrics(widget.songData), // Assuming Api.getLyrics returns a Future<String>
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              
              return Container(
                padding: const EdgeInsets.all(13.0),
                color: const Color.fromRGBO(34, 10, 41, 0.6),
                child: Text(
                  snapshot.data!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15.0),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
