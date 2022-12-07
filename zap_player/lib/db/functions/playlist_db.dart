import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/db/model/music_model.dart';
import 'package:zap_player/screens/splash_screen.dart';

class PlayListDB {
  static ValueNotifier<List<MusicModel>> playlistnotifier = ValueNotifier([]);
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
    log('song added');
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
  // Future<void> getAllPlaylistSongs() async {
  //   final playListDb = Hive.box<MusicModel>('playlistDB');
  //   viewPlaylistnotifier.value.clear();
  //   viewPlaylistnotifier.value.addAll(playListDb.values);

  //   viewPlaylistnotifier.notifyListeners();
  // }
}
