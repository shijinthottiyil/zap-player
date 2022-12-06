import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/screens/favorites/favbut_musicplaying.dart';
// import 'package:zap_player/db/functions/favourite_db.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    super.key,
    required this.songModelList,
  });

  final List<SongModel> songModelList;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  int _currentIndex = 0;
  bool _isShuffle = false;
   

  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          _currentIndex = index;
        });
        GetSongs.currentIndes = index;
      }
    });

    super.initState();

    playSong();
  }

  void playSong() {
    GetSongs.player.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    GetSongs.player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
              // FavoriteDb.favoriteSongs.notifyListeners();
            }),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: (() {}),
          //     icon: const Icon(Icons.more_vert),
          //   ),
          // ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              QueryArtworkWidget(
                keepOldArtwork: true,
                id: widget.songModelList[_currentIndex].id,
                type: ArtworkType.AUDIO,
                artworkHeight: 200,
                artworkWidth: 200,
                artworkFit: BoxFit.cover,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                      'assets/images/splash_screen_logo.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                widget.songModelList[_currentIndex].title.toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    overflow: TextOverflow.fade),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                widget.songModelList[_currentIndex].artist.toString() ==
                        '<unknown>'
                    ? 'UNKNOWN ARTIST'
                    : widget.songModelList[_currentIndex].artist
                        .toString()
                        .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: (() {
                      GetSongs.player.shuffleModeEnabled == true
                          ? GetSongs.player.setShuffleModeEnabled(false)
                          : GetSongs.player.setShuffleModeEnabled(true);
                    }),
                    icon: StreamBuilder<bool>(
                      stream: GetSongs.player.shuffleModeEnabledStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        _isShuffle = snapshot.data;
                        if (_isShuffle) {
                          return Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          );
                        } else {
                          return const Icon(
                            Icons.shuffle,
                            color: Colors.grey,
                          );
                        }
                      },
                    ),
                    // icon: GetSongs.player.shuffleModeEnabled == true
                    //     ? Icon(
                    //         Icons.shuffle,
                    //         color: Colors.blue,
                    //       )
                    //     : Icon(
                    //         Icons.shuffle,
                    //         color: Colors.white,
                    //       )
                    /*Icon(
                      GetSongs.player.shuffleModeEnabled == true
                          ? Icons.shuffle
                          : Icons.shuffle_on_outlined,
                      color: Colors.white,
                    ),*/
                  ),
                  FavButMusicPlaying(
                      songFavoriteMusicPlaying:
                          widget.songModelList[_currentIndex]),
                  // IconButton(
                  //   onPressed: (){

                  //   },
                  //   icon: Icon(
                  //     Icons.favorite_outline,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  IconButton(
                    onPressed: (() {}),
                    icon: Icon(
                      Icons.playlist_add,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: (() {
                      GetSongs.player.loopMode == LoopMode.off
                          ? GetSongs.player.setLoopMode(LoopMode.one)
                          : GetSongs.player.setLoopMode(LoopMode.off);
                    }),
                    icon: StreamBuilder<LoopMode>(
                      stream: GetSongs.player.loopModeStream,
                      builder: (BuildContext context,AsyncSnapshot snapshot) {
                        final loopMode = snapshot.data;
                        if(loopMode== LoopMode.off){
                          return Icon(
                            Icons.repeat,
                            color: Colors.grey,
                          );
                        } else{
                          return Icon(
                            Icons.repeat_one,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                    // icon: Icon(
                    //   GetSongs.player.loopMode == LoopMode.off
                    //       ? Icons.repeat_one
                    //       : Icons.repeat_one_on_outlined,
                    //   color: Colors.white,
                    // ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(trackHeight: 2),
                child: Slider(
                  min: const Duration(microseconds: 0).inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: ((value) {
                    setState(() {
                      changeToSeconds(value.toInt());
                      value = value;
                    });
                  }),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(23, 0, 23, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position.toString().substring(2, 7),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      _duration.toString().substring(2, 7),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: (() async {
                      if (GetSongs.player.hasPrevious) {
                        await GetSongs.player.seekToPrevious();
                        await GetSongs.player.play();
                      } else {
                        await GetSongs.player.play();
                      }
                    }),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    iconSize: MediaQuery.of(context).size.width * 0.07,
                  ),
                  IconButton(
                    onPressed: (() async {
                      if (GetSongs.player.playing) {
                        await GetSongs.player.pause();
                        setState(() {});
                      } else {
                        await GetSongs.player.play();
                        setState(() {});
                      }
                    }),
                    icon: Icon(GetSongs.player.playing
                        ? Icons.pause
                        : Icons.play_arrow),
                    color: Colors.white,
                    iconSize: MediaQuery.of(context).size.width * 0.2,
                  ),
                  IconButton(
                    onPressed: (() async {
                      if (GetSongs.player.hasNext) {
                        await GetSongs.player.seekToNext();
                        await GetSongs.player.play();
                      } else {
                        await GetSongs.player.play();
                      }
                    }),
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.white,
                    iconSize: MediaQuery.of(context).size.width * 0.07,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);

    GetSongs.player.seek(duration);
  }
}
