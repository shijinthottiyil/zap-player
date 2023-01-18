import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../view/widgets/widget_listtile.dart';

class ProviderSearchScreen with ChangeNotifier {
  late List<SongModel> allSongs;
  List<SongModel> foundSongs = [];
  final OnAudioQuery audioQueryObject = OnAudioQuery();
  final AudioPlayer searchPageAudioPlayer = AudioPlayer();

  void fetchingAllSongsAndAssigningToFoundSongs() async {
    allSongs = await audioQueryObject.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );
    foundSongs = allSongs;
    notifyListeners();
  }

  void runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    }
    if (enteredKeyword.isNotEmpty) {
      results = allSongs.where((element) {
        return element.displayNameWOExt
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase().trimRight());
      }).toList();
    }

    foundSongs = results;
    notifyListeners();
  }

  Widget? getListView(BuildContext context) {
    if (foundSongs.isNotEmpty) {
      return ListView.separated(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          itemBuilder: ((context, index) {
            return WidgetListTile(
              songModelList: foundSongs,
              id: foundSongs[index].id,
              title: foundSongs[index].title,
              artist: foundSongs[index].artist,
              index: index,
            );
            // return ListTile(
            //   contentPadding: EdgeInsets.only(
            //       left: MediaQuery.of(context).size.width * 0.025),
            //   tileColor: Colors.white,
            //   leading: QueryArtworkWidget(
            //     id: foundSongs[index].id,
            //     type: ArtworkType.AUDIO,
            //     nullArtworkWidget: CircleAvatar(
            //         backgroundColor: Colors.transparent,
            //         child: Image.asset(
            //           'assets/images/default_music_logo.png',
            //         )),
            //   ),
            //   title: Text(
            //     foundSongs[index].title.toUpperCase(),
            //     maxLines: 1,
            //     style: const TextStyle(
            //       fontWeight: FontWeight.bold,
            //       overflow: TextOverflow.fade,
            //     ),
            //   ),
            //   subtitle: Text(
            //       maxLines: 1,
            //       foundSongs[index].artist.toString() == '<unknown>'
            //           ? 'UNKNOWN ARTIST'
            //           : foundSongs[index].artist.toString().toUpperCase()),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(
            //           MediaQuery.of(context).size.width * 0.1)),
            //   onTap: () {
            //     GetSongs.player.pause();
            //     GetSongs.player.setAudioSource(
            //         GetSongs.createSongList(foundSongs),
            //         initialIndex: index);
            //     GetSongs.player.play();
            //     Navigator.push(context, MaterialPageRoute(builder: ((context) {
            //       return NowPlaying(
            //         songModelList: foundSongs,
            //       );
            //     })));
            //   },
            // );
          }),
          separatorBuilder: (context, index) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
          itemCount: foundSongs.length);
    } else {
      return null;
    }
  }
}
