import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/screens/now_playing_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

    setState(() {
      foundSongs = results;
    });
  }

  @override
  void initState() {
    fetchingAllSongsAndAssigningToFoundSongs();
    super.initState();
  }

  void updateList(String value) {
    setState(() {});
  }

  Widget? getListView() {
    if (foundSongs.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: ((context, index) {
            return ListTile(
              contentPadding: EdgeInsets.only(left: 10.0),
              tileColor: Colors.white,
              leading: QueryArtworkWidget(
                id: foundSongs[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/images/default_music_logo.png',
                    )),
              ),
              title: Text(
                foundSongs[index].title.toUpperCase(),
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade,
                ),
              ),
              subtitle: Text(
                  maxLines: 1,
                  foundSongs[index].artist.toString() == '<unknown>'
                      ? 'UNKNOWN ARTIST'
                      : foundSongs[index].artist.toString().toUpperCase()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              onTap: () {
                GetSongs.player.setAudioSource(
                    GetSongs.createSongList(foundSongs),
                    initialIndex: index);
                GetSongs.player.play();
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return NowPlaying(
                    songModelList: foundSongs,
                  );
                })));
              },
            );
          }),
          separatorBuilder: (context, index) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
          itemCount: foundSongs.length);
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            width: 340,
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                hintText: 'Artists,songs,or albums',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: ((value) {
                runFilter(value);
              }),
            ),
          )
        ],
      ),
      body: getListView(),
    );
  }
}
