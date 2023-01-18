import 'package:flutter/material.dart';

import '../song_controller.dart';

class ProviderMiniPlayer with ChangeNotifier {
  void mountedFun() async {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }

  Future<void> playBtnPressed(BuildContext context) async {
    if (GetSongs.player.playing) {
      await GetSongs.player.pause();
      notifyListeners();
    } else {
      await GetSongs.player.play();
      notifyListeners();
    }
  }

  Future<void> previousBtnPressed() async {
    if (GetSongs.player.hasPrevious) {
      await GetSongs.player.seekToPrevious();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  Future<void> nextBtnPressed() async {
    if (GetSongs.player.hasNext) {
      await GetSongs.player.seekToNext();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }
}
