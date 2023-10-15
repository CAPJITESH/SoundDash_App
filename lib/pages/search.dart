import 'package:SoundDash/api/song_api.dart';
import 'package:SoundDash/cards/search_song_card.dart';
import 'package:SoundDash/pages/playlist_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _textEditingController = TextEditingController();
  Timer? _debounce;
  Map<String, dynamic> _searchResults = {};

  @override
  void dispose() {
    _debounce?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  void _performSearch(String searchTerm) async {
    _searchResults = await Api.performSearch(searchTerm);

    setState(() {});
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 100), () {
      _performSearch(value);
    });
  }

  bool _isFullScreenVisible = false;
  Map<String, dynamic> AlbumData = {};

  void _handleCardPressed(Map<String, dynamic> pressedData) {
    setState(() {
      _isFullScreenVisible = true;
      AlbumData = pressedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 70, 1, 50),
                      const Color.fromARGB(255, 50, 1, 40),
                      const Color.fromARGB(255, 10, 1, 20),
                      Colors.black.withOpacity(1),
                    
                  ],
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  onChanged: _onTextChanged,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  ..._searchResults.entries.map((entry) {
                    String sectionTitle = entry.key;
                    List<dynamic> sectionData = entry.value;

                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(top: 25, bottom: 8),
                          child: Text(
                            sectionTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 219, 172, 255),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sectionData.length,
                          itemBuilder: (context, index) {
                            final sectionItemData = sectionData[index];

                            return SearchSongCard(
                              onCardPressed: _handleCardPressed,
                              songData: sectionItemData,
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
              ],
            ),
          ),
          if (_isFullScreenVisible)
            PlaylistView(
              albumData: AlbumData,
              onClose: (returnValue) {
                setState(() {
                  _isFullScreenVisible = false;
                  // Do something with the return value if needed
                });
              },
            )
        ],
      ),
    );
  }
}
