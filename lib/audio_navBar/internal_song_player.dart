import 'package:SoundDash/services/get_lyrics.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class InternalSongsPlayer extends StatefulWidget {
  final List<SongModel> playlistData;
  final int index;

  const InternalSongsPlayer(
      {Key? key, required this.playlistData, required this.index})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InternalSongsPlayerState createState() => _InternalSongsPlayerState();
}

class _InternalSongsPlayerState extends State<InternalSongsPlayer> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final ValueNotifier<Duration> _currentPositionNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _totalDurationNotifier =
      ValueNotifier(Duration.zero);
  // List<Audio> additionalSongs = [];

  bool isShuffling = false;

  @override
  void initState() {
    super.initState();
    setupPlaylist();
    print('inited dataa');

    audioPlayer.currentPosition.listen((duration) {
      _currentPositionNotifier.value = duration;
    });
    audioPlayer.current.listen((playing) {
      if (playing != null) {
        _totalDurationNotifier.value = playing.audio.duration;
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
    print(
        "ncnkxnkcnkn kvndkvnkdnskvnksdndkvnkdnkvnksdnkvnksdnkvnksnvknsknvkwkvbkwe mdv");
    print('sncksnkcnknkvnkndvkndknvkndkvnkenvk');

    print('snckssc;s,csccscnkcnknkvnkndvkndknvkndkvnkenvk');
    print('sncksnkcnknkvnkcwdf2f2f2cscndvkndknvkndkvnkenvk');
    print('sncksnkcnknkvnkndvkndknvkndwff3fefedckvnkenvk');
    print('sncksnkcnknkvnkndvkndknvkndkvnkenvkcsdvcevre');

    final List<Audio> playlistItems = [];
    print(widget.playlistData);

    print(widget.playlistData.length);

    audioPlayer.open(Audio.file(widget.playlistData[widget.index] as String),
        autoStart: true, showNotification: true);

    // Open the playlist with the created items
    // audioPlayer.open(
    //   Playlist(audios: playlistItems),
    //   showNotification: true,
    //   autoStart: true,
    // );
    setState(() {
      gotPlaylistData = true;
    });
  }

  shuffle() async {
    audioPlayer.toggleShuffle();
    setState(() {
      isShuffling = !isShuffling;
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
                        final metas = audio?.audio.metas;
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
                                    image: NetworkImage(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/2048px-Apple_Music_icon.svg.png'),
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
                                  width: 80,
                                  child: Text(
                                    metas?.title ?? '',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Text(
                                    metas?.artist ?? '',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 139, 139, 139)),
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

  final controller = PanelController();

  bool isOpen = false;

  _togglePanel() {
    setState(() {
      print(isOpen);
      isOpen ? controller.close() : controller.open();
      isOpen = !isOpen;
    });
  }

  Widget _showBottomSheet(
      BuildContext context, ScrollController scrollController) {
    return Container(
      // color: const Color.fromARGB(0, 163, 163, 163),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: _togglePanel,
            child: Column(
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 7),
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
                Center(
                  child: Container(
                    // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: 38,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
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
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= playlist.length) {
                          return Container();
                        }

                        final audio = playlist[index];
                        final meta = audio.metas;

                        final title = meta.title ?? '';

                        final imageLink =
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/2048px-Apple_Music_icon.svg.png';
                        final primaryArtists = meta.artist ?? '';

                        String playingTitle = audioPlayer.getCurrentAudioTitle;
                        String playingArtists =
                            audioPlayer.getCurrentAudioArtist;

                        return Dismissible(
                          key: ValueKey<Audio>(playlist[index]),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            audioPlayer.playlist!.removeAtIndex(index);
                            // playlistData.removeAt(index);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                  color: primaryArtists == playingArtists &&
                                          title == playingTitle
                                      ? const Color.fromARGB(255, 72, 255, 0)
                                      : Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              primaryArtists,
                              style: TextStyle(
                                  color: primaryArtists == playingArtists &&
                                          title == playingTitle
                                      ? const Color.fromARGB(255, 72, 255, 0)
                                      : Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              audioPlayer.playlistPlayAtIndex(index);
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
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

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
        body: Stack(
          children: [
            Container(
              color: Color.fromARGB(255, 34, 10, 41),
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
                      final metas = audio?.audio.metas;
                      return Column(
                        children: [
                           Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/2048px-Apple_Music_icon.svg.png', // Use the current song's image path
                              width: 250,
                              height: 250,
                            ),
                            
                          // const SizedBox(height: 10),
                          Text(
                            metas?.title ?? '', // Use the current song's title
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            metas?.artist ??
                                '', // Use the current song's artist
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 5),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.skip_previous_rounded),
                        onPressed: () => skipPrevious(),
                      ),
                      StreamBuilder<bool>(
                        stream: audioPlayer.isPlaying,
                        builder: (context, snapshot) {
                          final isPlaying = snapshot.data ?? false;
                          return IconButton(
                            iconSize: 30,
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
                        iconSize: 30,
                        color:
                            gotPlaylistData ? Colors.white : Colors.grey[500],
                        icon: const Icon(Icons.skip_next_rounded),
                        onPressed: () => skipNext(),
                      ),
                      IconButton(
                          onPressed: () {
                            shuffle();
                          },
                          iconSize: 30,
                          icon: isShuffling
                              ? const Icon(
                                  Icons.shuffle_rounded,
                                )
                              : const Icon(
                                  Icons.repeat,
                                )),
                    ],
                  ),
                ],
              ),
            ),
            if (gotPlaylistData)
              SlidingUpPanel(
                color: Color.fromARGB(255, 34, 10, 41).withOpacity(0.75),
                controller: controller,
                minHeight: 55,
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                borderRadius: BorderRadius.circular(30),
                backdropTapClosesPanel: true,
                panelBuilder: (sc) {
                  return _showBottomSheet(context, sc);
                },
              ),
          ],
        ),
      ),
    );
  }
}
