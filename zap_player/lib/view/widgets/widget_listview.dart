import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controller/song_controller.dart';
import '../screens/favorites/favorite_button.dart';
import '../screens/home_screen.dart';
import '../screens/now_playing_screen.dart';

class WidgetListViewSeparated extends StatelessWidget {
  final int itemCount;
  final List<SongModel> songModelList;

  const WidgetListViewSeparated({
    super.key,
    required this.itemCount,
    required this.songModelList,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.025,
          right: MediaQuery.of(context).size.width * 0.025),
      itemBuilder: ((context, index) {
        return ListTile(
          contentPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.025,
              right: MediaQuery.of(context).size.width * 0.04),
          tileColor: Colors.white,
          leading: QueryArtworkWidget(
            id: songModelList[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/default_music_logo.png',
                )),
          ),
          title: Text(
            songModelList[index].title.toUpperCase(),
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
            ),
          ),
          subtitle: Text(
            maxLines: 1,
            songModelList[index].artist.toString() == '<unknown>'
                ? 'UNKNOWN ARTIST'
                : songModelList[index].artist.toString().toUpperCase(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
          ),
          onTap: () {
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
          trailing: FavoriteButton(
            songFavorite: HomePage.startSong[index],
          ),
        );
      }),
      separatorBuilder: (context, index) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      itemCount: itemCount,
    );
  }
}
