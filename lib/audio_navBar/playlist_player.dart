import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';


class PlaylistPlayer extends StatefulWidget {
  final List<dynamic> playlistData;

  const PlaylistPlayer({Key? key, required this.playlistData})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlaylistPlayerState createState() => _PlaylistPlayerState();
}

class _PlaylistPlayerState extends State<PlaylistPlayer> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final ValueNotifier<Duration> _currentPositionNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _totalDurationNotifier =
      ValueNotifier(Duration.zero);
  List<Audio> additionalSongs = [];

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

  bool gotPlaylistData = false;

  void setupPlaylist() async {
    final List<Audio> playlistItems = [];
    print(widget.playlistData);

    print(widget.playlistData.length);
    for (final item in widget.playlistData) {
      playlistItems.add(
        Audio.network(
          item['downloadUrl'][2]
              ['link'], // Assuming downloadUrl is a list
          metas: Metas(
            title: item['name'],
            artist: item['primaryArtists'],
            album: item['album']['name'],
            image: MetasImage.network(item['image'][2]['link']),
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

    setState(() {
      gotPlaylistData = true;
    });
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
    await audioPlayer.pause();
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

  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void toggleCollapsed() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 5),
      height: isExpanded ? MediaQuery.of(context).size.height : null,
      curve: Curves.ease,
      child: isExpanded ? buildExpandedView() : buildCollapsedView(),
    );
  }

  Widget buildCollapsedView() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: toggleExpanded,
        child: Container(
          height: 78,
          color: const Color.fromARGB(255, 68, 12, 64),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ValueListenableBuilder<Duration>(
                  valueListenable: _currentPositionNotifier,
                  builder: (context, position, _) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        sliderTheme: const SliderThemeData(
                          trackHeight: 4.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 10.0),
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          // Set padding to zero
                          trackShape: RoundedRectSliderTrackShape(),
                          activeTrackColor: Color.fromARGB(255, 71, 14, 121),
                          inactiveTrackColor: Color.fromARGB(255, 126, 71, 154),
                          thumbColor: Colors.white,
                          overlayColor: Color.fromARGB(30, 71, 14, 121),
                        ),
                      ),
                      child: Slider(
                        value: position.inSeconds.toDouble(),
                        min: 0,
                        max: _totalDurationNotifier.value.inSeconds.toDouble(),
                        onChanged: (value) {
                          seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<Playing?>(
                      stream: audioPlayer.current,
                      builder: (context, snapshot) {
                        final playing = snapshot.data;
                        final audio = playing?.audio;
                        final metas = audio?.audio?.metas;
                        return Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, top: 8.0),
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(metas?.image?.path ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    metas?.title ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: 130,
                                  child: Text(
                                    metas?.artist ?? '',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(width: 4),
                          ],
                        );
                      },
                    ),
                    // SizedBox(width: 5),
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.skip_previous_rounded),
                      onPressed: () => skipPrevious(),
                    ),
                    StreamBuilder<bool>(
                      stream: audioPlayer.isPlaying,
                      builder: (context, snapshot) {
                        final isPlaying = snapshot.data ?? false;
                        return IconButton(
                          iconSize: 20,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: () =>
                              isPlaying ? pauseMusic() : playMusic(),
                        );
                      },
                    ),
                    IconButton(
                      iconSize: 20,
                      color: gotPlaylistData ? Colors.white : Colors.grey[500],
                      icon: const Icon(Icons.skip_next_rounded),
                      onPressed: () => skipNext(),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                // SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 2.0) {
              Navigator.pop(context);
            }
          },
          child: DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
              expand: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Color.fromARGB(0, 163, 163, 163),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 25, bottom: 8),
                        child: const Center(
                          child: Text(
                            "Next in Queue",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 182, 103, 243),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<Playing?>(
                            stream: audioPlayer.current,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data == null) {
                                return const Text('No playlist data');
                              }

                              final playlist = audioPlayer.playlist!.audios;

                              if (playlist.isNotEmpty) {
                                return ListView.builder(
                                  controller: scrollController,
                                  itemCount: playlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >= playlist.length) {
                                      return Container();
                                    }

                                    final audio = playlist[index];
                                    final meta = audio.metas;

                                    final title = meta.title ?? '';

                                    final imageLink = meta.image?.path ?? '';
                                    final primaryArtists = meta.artist ?? '';

                                    String playingTitle =
                                        audioPlayer.getCurrentAudioTitle;
                                    String playingArtists =
                                        audioPlayer.getCurrentAudioArtist;

                                    return Dismissible(
                                      key: ValueKey<Audio>(playlist[index]),
                                      direction: DismissDirection.horizontal,
                                      onDismissed: (direction) {
                                        audioPlayer.playlist!
                                            .removeAtIndex(index);
                                        // playlistData.removeAt(index);
                                      },
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      child: ListTile(
                                        // tileColor: Colors.black.withOpacity(0.7),
                                        leading: Image.network(
                                          imageLink,
                                          height: 50,
                                          width: 50,
                                        ),
                                        title: Text(
                                          title,
                                          style: TextStyle(
                                              color: primaryArtists ==
                                                          playingArtists &&
                                                      title == playingTitle
                                                  ? Color.fromARGB(
                                                      255, 72, 255, 0)
                                                  : Colors.white),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          primaryArtists,
                                          style: TextStyle(
                                              color: primaryArtists ==
                                                          playingArtists &&
                                                      title == playingTitle
                                                  ? Color.fromARGB(
                                                      255, 72, 255, 0)
                                                  : Colors.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          audioPlayer
                                              .playlistPlayAtIndex(index);
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Text("No Songs in Queue");
                              }
                            }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildExpandedView() {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press event
        toggleExpanded();

        // Return false to prevent the default back button behavior
        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: toggleExpanded,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                iconSize: 30,
              ),
              StreamBuilder<Playing?>(
                stream: audioPlayer.current,
                builder: (context, snapshot) {
                  final playing = snapshot.data;
                  final audio = playing?.audio;
                  final metas = audio?.audio?.metas;
                  return Column(
                    children: [
                      Image.network(
                        metas?.image?.path ??
                            '', // Use the current song's image path
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        metas?.title ?? '', // Use the current song's title
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        onPressed: () => isPlaying ? pauseMusic() : playMusic(),
                      );
                    },
                  ),
                  IconButton(
                    iconSize: 50,
                    color: gotPlaylistData ? Colors.white : Colors.grey[500],
                    icon: Icon(Icons.skip_next_rounded),
                    onPressed: () => skipNext(),
                  ),
                ],
              ),
              if (gotPlaylistData)
                ElevatedButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  child: Text('Next in Queue'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
