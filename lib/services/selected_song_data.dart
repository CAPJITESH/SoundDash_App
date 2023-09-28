import 'package:flutter/material.dart';

class SelectedSongDataProvider extends ChangeNotifier {
  dynamic _selectedSongData;
  dynamic _selectedIndex;

  dynamic get selectedSongData => _selectedSongData;
  dynamic get selectedIndex => _selectedIndex;

  void updateSelectedSongData(dynamic songData) {
    if (songData is Map<String, dynamic>) {
      _selectedSongData = songData;
    }
    notifyListeners();
  }

  void startPlaylistSongs(dynamic playlist, int index) {
    _selectedIndex = index;
    _selectedSongData = playlist;
    notifyListeners();
  }
}
