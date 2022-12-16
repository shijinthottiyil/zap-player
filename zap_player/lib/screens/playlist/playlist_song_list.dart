// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
// import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/playlist_db.dart';
import 'package:zap_player/db/model/music_model.dart';

class PlaylistSongListScreen extends StatefulWidget {
  const PlaylistSongListScreen({Key? key, required this.playlist})
      : super(key: key);

  final MusicModel playlist;

  @override
  State<PlaylistSongListScreen> createState() => _PlaylistSongState();
}

class _PlaylistSongState extends State<PlaylistSongListScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<SongModel>> item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Songs Found',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.separated(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.025,
                  right: MediaQuery.of(context).size.width * 0.025),
              itemBuilder: ((ctx, index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.025,
                      right: MediaQuery.of(context).size.width * 0.04),
                  tileColor: Colors.white,
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'assets/images/default_music_logo.png',
                        )),
                  ),
                  title: Text(
                    item.data![index].title.toUpperCase(),
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  subtitle: Text(
                    maxLines: 1,
                    item.data![index].artist.toString() == '<unknown>'
                        ? 'UNKNOWN ARTIST'
                        : item.data![index].artist.toString().toUpperCase(),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.1),
                  ),
                  trailing: !widget.playlist.isValueIn(item.data![index].id)
                      ? IconButton(
                          onPressed: (() {
                            setState(
                              () {
                                playlistCheck(item.data![index]);
                                PlayListDB.playlistnotifier.notifyListeners();
                              },
                            );
                          }),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        )
                      : IconButton(
                          onPressed: (() {
                            setState(() {
                              widget.playlist.deleteData(item.data![index].id);
                            });
                          }),
                          icon: const Icon(
                            Icons.done,
                            color: Colors.black,
                          ),
                        ),
                );
              }),
              separatorBuilder: (context, index) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
              itemCount: item.data!.length);
        },
      ),
    );
  }

  void playlistCheck(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);

      // log('song added');

    }
    // else {
    //   widget.playlist.delete();
    // }
  }
}
