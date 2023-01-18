import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class WidgetListTilePlayListFavorite extends StatelessWidget {
  final int id;
  final String title;
  final String artist;
  final VoidCallback trailingAction;
  final VoidCallback onTapFn;
  final Widget iconData;
  const WidgetListTilePlayListFavorite({
    super.key,
    required this.id,
    required this.title,
    required this.artist,
    required this.trailingAction,
    required this.onTapFn,
    required this.iconData,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(
        onPressed: trailingAction,
        icon: iconData,
      ),
      contentPadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.025,
        right: MediaQuery.of(context).size.width * 0.04,
      ),
      tileColor: Colors.white,
      leading: QueryArtworkWidget(
        id: id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/images/default_music_logo.png',
          ),
        ),
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
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.1,
        ),
      ),
      onTap: onTapFn,
      // onTap: () {
      //   List<SongModel> favoriteList = [...favoriteData];
      //   GetSongs.player.setAudioSource(GetSongs.createSongList(favoriteList),
      //       initialIndex: index);
      //   GetSongs.player.play();
      //   Navigator.push(context, MaterialPageRoute(builder: ((context) {
      //     return NowPlaying(
      //       songModelList: favoriteList,
      //     );
      //   }),),);
      // },
    );
  }
}
