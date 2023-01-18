import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/provider_favbut.dart';

class FavButMusicPlaying extends StatelessWidget {
  const FavButMusicPlaying({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return Consumer<ProviderFavBut>(
          builder: (context, value, child) {
            return value.iconButton(
              songFavoriteMusicPlaying,
              Colors.white,
            );
          },
        );
        // return IconButton(
        //   onPressed: () {
        //     if (FavoriteDb.isFavor(songFavoriteMusicPlaying)) {
        //       FavoriteDb.delete(songFavoriteMusicPlaying.id);
        //     } else {
        //       FavoriteDb.add(songFavoriteMusicPlaying);
        //     }

        //     FavoriteDb.favoriteSongs.notifyListeners();
        //   },
        //   icon: FavoriteDb.isFavor(songFavoriteMusicPlaying)
        //       ? const Icon(
        //           Icons.favorite,
        //           color: Colors.red,
        //         )
        //       : const Icon(
        //           Icons.favorite_border,
        //           color: Colors.white,
        //         ),
        // );
      },
    );
  }
}
