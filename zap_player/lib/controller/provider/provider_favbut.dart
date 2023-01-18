import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../db/functions/favourite_db.dart';

class ProviderFavBut with ChangeNotifier {
  Widget iconButton(SongModel song, Color? favoriteIconColor) {
    return IconButton(
      onPressed: () {
        if (FavoriteDb.isFavor(song)) {
          FavoriteDb.delete(song.id);
        } else {
          FavoriteDb.add(song);
        }

        FavoriteDb.favoriteSongs.notifyListeners();
      },
      icon: FavoriteDb.isFavor(song)
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : Icon(
              Icons.favorite_border,
              color: favoriteIconColor,
            ),
    );
  }
}
