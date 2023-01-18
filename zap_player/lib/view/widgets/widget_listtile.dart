import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controller/song_controller.dart';
import '../screens/now_playing_screen.dart';

class WidgetListTile extends StatelessWidget {
  final int id;
  final String title;
  final String? artist;
  final int index;
  final List<SongModel> songModelList;
  const WidgetListTile({
    super.key,
    required this.id,
    required this.title,
    required this.artist,
    required this.index,
    required this.songModelList,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.025),
      tileColor: Colors.white,
      leading: QueryArtworkWidget(
        id: id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset(
              'assets/images/default_music_logo.png',
            )),
      ),
      title: Text(
        title.toUpperCase(),
        maxLines: 1,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.fade,
        ),
      ),
      subtitle: Text(
        maxLines: 1,
        artist.toString() == '<unknown>'
            ? 'UNKNOWN ARTIST'
            : artist.toString().toUpperCase(),
      ),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.1)),
      onTap: () {
        GetSongs.player.pause();
        GetSongs.player.setAudioSource(
            GetSongs.createSongList(
              songModelList,
            ),
            initialIndex: index);
        GetSongs.player.play();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return NowPlaying(
                songModelList: songModelList,
              );
            }),
          ),
        );
      },
    );
  }
}
