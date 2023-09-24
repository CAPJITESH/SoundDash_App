import 'package:SoundDash/api/song_api.dart';
import 'package:flutter/material.dart';

class GetLyrics extends StatefulWidget {
  final String id;
  const GetLyrics({super.key, required this.id});

  @override
  State<GetLyrics> createState() => _GetLyricsState();
}

class _GetLyricsState extends State<GetLyrics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: Api.getLyrics(widget.id), // Assuming Api.getLyrics returns a Future<String>
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 17.0),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
