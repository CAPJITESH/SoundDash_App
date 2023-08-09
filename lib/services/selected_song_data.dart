import 'package:flutter/material.dart';

class SelectedSongDataProvider extends ChangeNotifier {
  dynamic _selectedSongData;

  dynamic get selectedSongData => _selectedSongData;

  void updateSelectedSongData(dynamic songData) {
    if (songData is Map<String, dynamic>) {
      _selectedSongData = songData;
    } else if (songData is List<dynamic>) {
      _selectedSongData = songData;
    }
    notifyListeners();
  }
}

