import 'package:SoundDash/cards/search_song_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'dart:convert';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _textEditingController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _searchResults = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  void _performSearch(String searchTerm) async {
    final endpoint =
        'https://saavn.me/search/songs?query=$searchTerm&page=1&limit=25';
    // print(endpoint);

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final results = responseBody['data']['results'] as List<dynamic>?;

        setState(() {
          _searchResults = results ?? [];
        });
      } else {
        throw Exception('Failed to fetch API response');
      }
    } catch (error) {
      print('API Error: $error');
    }
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 100), () {
      _performSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final songData = _searchResults[index];
                return SearchSongCard(songData: songData);
              },
            ),
          ),
        ],
      ),
    );
  }
}
