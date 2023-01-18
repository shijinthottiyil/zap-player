import 'package:flutter/material.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controller/song_controller.dart';
import '../../widgets/widget_listtile_playlist_favorite.dart';
import '../now_playing_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return SafeArea(
          child: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: FavoriteDb.favoriteSongs,
              builder: (BuildContext ctx, List<SongModel> favoriteData,
                  Widget? child) {
                if (favoriteData.isEmpty) {
                  return const Center(
                    child: Text(
                      'NO FAVORITE SONGS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  );
                } else {
                  return ListView.separated(
                    padding: EdgeInsets.only(
                      left: width * 0.025,
                      right: width * 0.025,
                      top: width * 0.025,
                    ),
                    itemBuilder: ((ctx, index) {
                      return WidgetListTilePlayListFavorite(
                        id: favoriteData[index].id,
                        title: favoriteData[index].title,
                        artist: favoriteData[index].artist.toString(),
                        trailingAction: (() {
                          FavoriteDb.favoriteSongs.notifyListeners();
                          FavoriteDb.delete(favoriteData[index].id);
                        }),
                        onTapFn: (() {
                          List<SongModel> favoriteList = [...favoriteData];
                          GetSongs.player.setAudioSource(
                              GetSongs.createSongList(favoriteList),
                              initialIndex: index);
                          GetSongs.player.play();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return NowPlaying(
                                  songModelList: favoriteList,
                                );
                              }),
                            ),
                          );
                        }),
                        iconData: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      );
                    }),
                    separatorBuilder: (context, index) => SizedBox(
                      height: height * 0.01,
                    ),
                    itemCount: favoriteData.length,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
