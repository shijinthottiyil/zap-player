import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/db/functions/favourite_db.dart';

class FavButMusicPlaying extends StatefulWidget {
  const FavButMusicPlaying({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  State<FavButMusicPlaying> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavButMusicPlaying> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)) {
                FavoriteDb.delete(widget.songFavoriteMusicPlaying.id);
              } else {
                FavoriteDb.add(widget.songFavoriteMusicPlaying);
              }

              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
          );
        });
  }
}
