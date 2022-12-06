import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/playlist_db.dart';
import 'package:zap_player/db/model/music_model.dart';
import 'package:zap_player/screens/now_playing_screen.dart';
import 'package:zap_player/screens/playlist/playlist_song_list.dart';

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
    PlayListDB().getAllPlaylist();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    PlayListDB().getAllPlaylist();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.playlist.name),
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
            icon: Icon(Icons.add),
          ),
        ],
      ),
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
                      'Press + To Add Songs',
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    itemBuilder: ((context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 10.0),
                        tileColor: Colors.white,
                        leading: QueryArtworkWidget(
                          id: playlistsong[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/images/default_music_logo.png',
                              )),
                        ),
                        title: Text(
                          playlistsong[index].title.toUpperCase(),
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        subtitle: Text(
                          maxLines: 1,
                          playlistsong[index].artist.toString() == '<unknown>'
                              ? 'UNKNOWN ARTIST'
                              : playlistsong[index]
                                  .artist
                                  .toString()
                                  .toUpperCase(),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        onTap: () {
                          List<SongModel> newlist = [...playlistsong];
                          GetSongs.player.setAudioSource(
                              GetSongs.createSongList(newlist),
                              initialIndex: index);
                          GetSongs.player.play();
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return NowPlaying(
                              songModelList: playlistsong,
                            );
                          })));
                        },
                        trailing: IconButton(
                            onPressed: (() {
                              widget.playlist.deleteData(
                                playlistsong[index].id,
                              );
                            }),
                            icon: Icon(Icons.delete)),
                      );
                    }),
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                    itemCount: playlistsong.length);
          }),
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

