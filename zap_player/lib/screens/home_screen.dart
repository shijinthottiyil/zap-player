import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/screens/favorites/favorite_button.dart';
import 'package:zap_player/screens/now_playing_screen.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/screens/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static List<SongModel> startSong = [];
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color whiteColor = Colors.white;
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
    Permission.storage.request();
  }

  final _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // floatHeaderSlivers: true,
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.lightBlue,
                elevation: 0,
                expandedHeight: MediaQuery.of(context).size.height * 0.22,
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'ZAP PLAYER',
                    textAlign: TextAlign.start,
                  ),
                ),
                // floating: true,
                // snap: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const SearchPage();
                          },
                        ));
                      },
                      icon: const Icon(
                        Icons.search,
                      ))
                ],
              )
            ]),
        body: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: ((context, item) {
              if (item.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              } else if (item.data!.isEmpty) {
                return const Center(
                    child: Text(
                  "No Songs Found",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ));
              } else {
                HomePage.startSong = item.data!;
                GetSongs.songscopy = item.data!;

                if (!FavoriteDb.isInitialized) {
                  FavoriteDb.intialize(item.data!);
                }

                return ListView.separated(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.025,
                        right: MediaQuery.of(context).size.width * 0.025),
                    itemBuilder: ((context, index) {
                      return ListTile(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.025,
                              right: MediaQuery.of(context).size.width * 0.04),
                          tileColor: whiteColor,
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
                                : item.data![index].artist
                                    .toString()
                                    .toUpperCase(),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.1)),
                          onTap: () {
                            GetSongs.player.setAudioSource(
                                GetSongs.createSongList(item.data!),
                                initialIndex: index);
                            GetSongs.player.play();
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return NowPlaying(
                                songModelList: item.data!,
                              );
                            })));
                          },
                          trailing: FavoriteButton(
                              songFavorite: HomePage.startSong[index]));
                    }),
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                    itemCount: item.data!.length);
              }
            })),
      ),
    );
  }
}
