import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/db/model/music_model.dart';
import 'package:zap_player/view/screens/splash_screen.dart';

class PlayListDB {
  static ValueNotifier<List<MusicModel>> playlistnotifier = ValueNotifier([]);
  static final playListDb = Hive.box<MusicModel>('playlistDb');

//  ValueNotifier<List<MusicModel>> viewPlaylistnotifier = ValueNotifier([]);

  static Future<void> playlistAdd(MusicModel value) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    await playListDb.add(value);

    playlistnotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    playlistnotifier.value.clear();
    playlistnotifier.value.addAll(playListDb.values);

    playlistnotifier.notifyListeners();
  }

  static Future<void> playlistDelete(int index) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');

    await playListDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    final musicDb = Hive.box<int>('FavoriteDB');
    await musicDb.clear();
    await playListDb.clear();

    FavoriteDb.favoriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }
}
