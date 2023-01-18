import 'package:flutter/material.dart';
import 'package:zap_player/db/functions/playlist_db.dart';

import '../../db/model/music_model.dart';

class ProviderPlaylistScreen with ChangeNotifier {
  final nameController = TextEditingController();
  Future<void> whenButtonClicked(BuildContext context) async {
    final name = nameController.text.trim();
    final music = MusicModel(
      songId: [],
      name: name,
    );
    final data = PlayListDB.playListDb.values.map(
      (e) {
        return e.name.trim();
      },
    ).toList();

    if (name.isEmpty) {
      return;
    } else if (data.contains(music.name)) {
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 200.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        content: const Text(
          'Name Unavilable',
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      PlayListDB.playlistAdd(music);
      nameController.clear();
      Navigator.pop(context);
    }
  }
}
