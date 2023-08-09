import 'package:SoundDash/api/song_api.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayerBackgroundPlaylist extends StatefulWidget {
  final Map<String, dynamic> songData;

  AudioPlayerBackgroundPlaylist({required this.songData});

  @override
  _AudioPlayerBackgroundPlaylistState createState() =>
      _AudioPlayerBackgroundPlaylistState();
}

class _AudioPlayerBackgroundPlaylistState
    extends State<AudioPlayerBackgroundPlaylist> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final ValueNotifier<Duration> _currentPositionNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _totalDurationNotifier =
      ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    setupPlaylist();
    audioPlayer.currentPosition.listen((duration) {
      _currentPositionNotifier.value = duration;
    });
    audioPlayer.current.listen((playing) {
      if (playing != null && playing.audio != null) {
        _totalDurationNotifier.value = playing.audio!.duration!;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    _currentPositionNotifier.dispose();
    _totalDurationNotifier.dispose();
  }

  void setupPlaylist() async {
    // Fetch data from the API
    final List<Map<String, dynamic>> playlistData =
        await Api.getReco(widget.songData['id']);

    // Create a list of Audio items using the fetched data
    final List<Audio> playlistItems = [];

    // Add the initial song
    playlistItems.add(
      Audio.network(
        widget.songData['downloadUrl'][2]
            ['link'], // Assuming downloadUrl is a list
        metas: Metas(
          title: widget.songData['name'],
          artist: widget.songData['primaryArtists'],
          album: widget.songData['album']['name'],
          image: MetasImage.network(widget.songData['image'][2]['link']),
        ),
      ),
    );

    // Add the songs from the API response
    for (final item in playlistData) {
      playlistItems.add(
        Audio.network(
          item['data'][0]['downloadUrl'][2]['link'], // Assuming downloadUrl is a list
          metas: Metas(
            title: item['data'][0]['name'],
            artist: item['data'][0]['primaryArtists'],
            album: item['data'][0]['album']['name'],
            image: MetasImage.network(item['data'][0]['image'][2]['link']),
          ),
        ),
      );
    }

    // Open the playlist with the created items
    audioPlayer.open(
      Playlist(audios: playlistItems),
      showNotification: true,
      autoStart: true,
    );
  }

  playMusic() async {
    await audioPlayer.play();
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    await audioPlayer.previous();
  }

  skipNext() async {
    await audioPlayer.next();
  }

  seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<Playing?>(
            stream: audioPlayer.current,
            builder: (context, snapshot) {
              final playing = snapshot.data;
              final audio = playing?.audio;
              final metas = audio?.audio?.metas;
              return Column(
                children: [
                  Image.network(
                    metas?.image?.path ?? '', // Use the current song's image path
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    metas?.title ?? '', // Use the current song's title
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    metas?.artist ?? '', // Use the current song's artist
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          ValueListenableBuilder<Duration>(
            valueListenable: _currentPositionNotifier,
            builder: (context, position, _) {
              return Slider(
                value: position.inSeconds.toDouble(),
                min: 0,
                max: _totalDurationNotifier.value.inSeconds.toDouble(),
                onChanged: (value) {
                  seekTo(Duration(seconds: value.toInt()));
                },
              );
            },
          ),
          SizedBox(height: 5),
          ValueListenableBuilder<Duration>(
            valueListenable: _currentPositionNotifier,
            builder: (context, position, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(position)),
                  Text(formatDuration(_totalDurationNotifier.value)),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 50,
                icon: Icon(Icons.skip_previous_rounded),
                onPressed: () => skipPrevious(),
              ),
              StreamBuilder<bool>(
                stream: audioPlayer.isPlaying,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    iconSize: 50,
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    onPressed: () => isPlaying ? pauseMusic() : playMusic(),
                  );
                },
              ),
              IconButton(
                iconSize: 50,
                icon: Icon(Icons.skip_next_rounded),
                onPressed: () => skipNext(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
