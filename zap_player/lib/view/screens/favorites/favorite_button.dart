import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/provider_favbut.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.songFavorite});
  final SongModel songFavorite;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (
        BuildContext ctx,
        List<SongModel> favoriteData,
        Widget? child,
      ) {
        return Consumer<ProviderFavBut>(
          builder: (context, value, child) {
            return value.iconButton(
              songFavorite,
              Colors.black,
            );
          },
        );
        // return IconButton(
        //   onPressed: () {
        //     if (FavoriteDb.isFavor(songFavorite)) {
        //       FavoriteDb.delete(songFavorite.id);
        //     } else {
        //       FavoriteDb.add(songFavorite);
        //     }

        //     FavoriteDb.favoriteSongs.notifyListeners();
        //   },
        //   icon: FavoriteDb.isFavor(songFavorite)
        //       ? Icon(
        //           Icons.favorite,
        //           color: Colors.red[600],
        //         )
        //       : const Icon(
        //           Icons.favorite_border_rounded,
        //           color: Colors.black,
        //         ),
        // );
      },
    );
  }
}
