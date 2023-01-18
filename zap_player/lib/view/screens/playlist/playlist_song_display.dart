import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/playlist_db.dart';
import 'package:zap_player/db/model/music_model.dart';
import 'package:zap_player/view/screens/now_playing_screen.dart';
import 'package:zap_player/view/screens/playlist/playlist_song_list.dart';

import '../../widgets/widget_listtile_playlist_favorite.dart';

class PlaylistSongDisplayScreen extends StatefulWidget {
  const PlaylistSongDisplayScreen(
      {super.key, required this.playlist, required this.folderindex});
  final MusicModel playlist;
  final int folderindex;

  @override
  State<PlaylistSongDisplayScreen> createState() =>
      _PlaylistSongDisplayScreenState();
}

class _PlaylistSongDisplayScreenState extends State<PlaylistSongDisplayScreen> {
  late List<SongModel> playlistsong;
  @override
  void initState() {
    PlayListDB.getAllPlaylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  title: Text(widget.playlist.name),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return PlaylistSongListScreen(
                              playlist: widget.playlist,
                            );
                          }),
                        );
                      }),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              ]),
          body: ValueListenableBuilder(
              valueListenable: Hive.box<MusicModel>(
                'playlistDB',
              ).listenable(),
              builder:
                  (BuildContext context, Box<MusicModel> value, Widget? child) {
                playlistsong = listPlaylist(
                  value.values.toList()[widget.folderindex].songId,
                );

                return playlistsong.isEmpty
                    ? const Center(
                        child: Text(
                          'NO SONGS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(
                          left: width * 0.025,
                          right: width * 0.025,
                        ),
                        itemBuilder: ((context, index) {
                          return WidgetListTilePlayListFavorite(
                            id: playlistsong[index].id,
                            title: playlistsong[index].title,
                            artist: playlistsong[index].artist.toString(),
                            trailingAction: (() {
                              widget.playlist.deleteData(
                                playlistsong[index].id,
                              );
                            }),
                            onTapFn: () {
                              List<SongModel> newlist = [...playlistsong];
                              GetSongs.player.stop();
                              GetSongs.player.setAudioSource(
                                  GetSongs.createSongList(newlist),
                                  initialIndex: index);
                              GetSongs.player.play();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return NowPlaying(
                                  songModelList: GetSongs.playingSongs,
                                );
                              })));
                            },
                            iconData: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) => SizedBox(
                              height: height * 0.01,
                            ),
                        itemCount: playlistsong.length);
              }),
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(
    List<int> data,
  ) {
    List<SongModel> plsongs = [];

    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          plsongs.add(GetSongs.songscopy[i]);
        }
      }
    }

    return plsongs;
  }
}
