import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/db/functions/favourite_db.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.songFavorite});
  final SongModel songFavorite;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(widget.songFavorite)) {
                FavoriteDb.delete(widget.songFavorite.id);
              } else {
                FavoriteDb.add(widget.songFavorite);
              }

              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(widget.songFavorite)
                ? Icon(
                    Icons.favorite,
                    color: Colors.red[600],
                  )
                : const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.black,
                  ),
          );
        });
  }
}
