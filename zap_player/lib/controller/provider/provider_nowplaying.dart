import 'package:flutter/material.dart';

import '../../db/functions/favourite_db.dart';
import '../song_controller.dart';

class ProviderNowPlaying with ChangeNotifier {
  Duration duration = const Duration();
  Duration position = const Duration();
  int currentIndex = 0;

  Future<bool> onWillPop() async {
    FavoriteDb.favoriteSongs.notifyListeners();
    return true;
  }

  void backButtonPressed(BuildContext context) {
    Navigator.pop(context);
    FavoriteDb.favoriteSongs.notifyListeners();
  }

  void playSong() {
    GetSongs.player.durationStream.listen((d) {
      duration = d!;
      notifyListeners();
    });
    GetSongs.player.positionStream.listen((p) {
      position = p;
      notifyListeners();
    });
  }

  void initStateFn() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex = index;
        GetSongs.currentIndes = index;
        notifyListeners();
      }
    });
  }

  Future<void> previousBtn() async {
    if (GetSongs.player.hasPrevious) {
      await GetSongs.player.seekToPrevious();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  Future<void> playBtn() async {
    if (GetSongs.player.playing) {
      await GetSongs.player.pause();
      notifyListeners();
    } else {
      await GetSongs.player.play();
      notifyListeners();
    }
  }

  Future<void> nextBtn() async {
    if (GetSongs.player.hasNext) {
      await GetSongs.player.seekToNext();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  void changeToSeconds(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());

    GetSongs.player.seek(duration);
    // seconds = seconds;
    notifyListeners();
  }
}
