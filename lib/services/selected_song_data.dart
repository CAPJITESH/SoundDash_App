import 'package:flutter/material.dart';

class SelectedSongDataProvider extends ChangeNotifier {
  dynamic _selectedSongData;
  dynamic _selectedIndex;
  dynamic _isOffline;

  dynamic get selectedSongData => _selectedSongData;
  dynamic get selectedIndex => _selectedIndex;
  dynamic get isOffline => _isOffline;

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

  void offlinePlayer(dynamic playlist, int index, bool isOffline) {
    _selectedIndex = index;
    _selectedSongData = playlist;
    _isOffline = isOffline;
    notifyListeners();
  }
}
