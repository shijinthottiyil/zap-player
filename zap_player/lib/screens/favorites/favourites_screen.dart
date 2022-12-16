import 'package:flutter/material.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/screens/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025,
                        top: MediaQuery.of(context).size.width * 0.025,
                      ),
                      itemBuilder: ((ctx, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.025,
                              right: MediaQuery.of(context).size.width * 0.04),
                          tileColor: Colors.white,
                          leading: QueryArtworkWidget(
                            id: favoriteData[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                  'assets/images/default_music_logo.png',
                                )),
                          ),
                          title: Text(
                            favoriteData[index].title.toUpperCase(),
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          subtitle: Text(
                            maxLines: 1,
                            favoriteData[index].artist.toString() == '<unknown>'
                                ? 'UNKNOWN ARTIST'
                                : favoriteData[index]
                                    .artist
                                    .toString()
                                    .toUpperCase(),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.1)),
                          onTap: () {
                            List<SongModel> favoriteList = [...favoriteData];
                            GetSongs.player.setAudioSource(
                                GetSongs.createSongList(favoriteList),
                                initialIndex: index);
                            GetSongs.player.play();
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return NowPlaying(
                                songModelList: favoriteList,
                              );
                            })));
                          },
                          trailing: IconButton(
                              onPressed: (() {
                                FavoriteDb.favoriteSongs.notifyListeners();
                                FavoriteDb.delete(favoriteData[index].id);
                              }),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              )),
                        );
                      }),
                      separatorBuilder: (context, index) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                      itemCount: favoriteData.length);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
