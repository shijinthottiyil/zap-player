import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/view/screens/favorites/favbut_musicplaying.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/provider_nowplaying.dart';

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
  bool _isShuffle = false;

  @override
  void initState() {
    Provider.of<ProviderNowPlaying>(
      context,
      listen: false,
    ).initStateFn();
    Provider.of<ProviderNowPlaying>(
      context,
      listen: false,
    ).playSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    debugPrint('now playing screen rebuilds ');
    final providerWL = Provider.of<ProviderNowPlaying>(context);
    final providerWOL = Provider.of<ProviderNowPlaying>(context, listen: false);
    var artWorkHeight = height * 0.25;
    return WillPopScope(
      onWillPop: Provider.of<ProviderNowPlaying>(context).onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NOW PLAYING'),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: (() {
              providerWOL.backButtonPressed(context);
            }),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.07,
              ),
              Consumer<ProviderNowPlaying>(
                builder: (context, value, child) => QueryArtworkWidget(
                  keepOldArtwork: true,
                  id: widget.songModelList[value.currentIndex].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: artWorkHeight,
                  artworkWidth: artWorkHeight,
                  artworkBorder: BorderRadius.circular(width * 0.04),
                  nullArtworkWidget: ClipRRect(
                    child: Image.asset(
                      'assets/images/splash_screen_logo.png',
                      height: artWorkHeight,
                      width: artWorkHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Text(
                widget.songModelList[providerWL.currentIndex].title
                    .toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05,
                  overflow: TextOverflow.fade,
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                widget.songModelList[providerWL.currentIndex].artist
                            .toString() ==
                        '<unknown>'
                    ? 'UNKNOWN ARTIST'
                    : widget.songModelList[providerWL.currentIndex].artist
                        .toString()
                        .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: height * 0.03,
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
                          return const Icon(
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
                  ),
                  FavButMusicPlaying(
                    songFavoriteMusicPlaying:
                        widget.songModelList[providerWOL.currentIndex],
                  ),
                  IconButton(
                    onPressed: (() {
                      GetSongs.player.loopMode == LoopMode.off
                          ? GetSongs.player.setLoopMode(LoopMode.one)
                          : GetSongs.player.setLoopMode(LoopMode.off);
                    }),
                    icon: StreamBuilder<LoopMode>(
                      stream: GetSongs.player.loopModeStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        final loopMode = snapshot.data;
                        if (loopMode == LoopMode.off) {
                          return const Icon(
                            Icons.repeat,
                            color: Colors.grey,
                          );
                        } else {
                          return const Icon(
                            Icons.repeat_one,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Consumer<ProviderNowPlaying>(
                builder: (context, value, child) => SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 1),
                  child: Slider(
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    max: value.duration.inSeconds.toDouble(),
                    value: value.position.inSeconds.toDouble(),
                    onChanged: ((seconds) {
                      value.changeToSeconds(seconds);
                    }),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: width * 0.06, right: width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      providerWL.position.toString().substring(2, 7),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      providerWL.duration.toString().substring(2, 7),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: (() async {
                      providerWOL.previousBtn();
                    }),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    iconSize: width * 0.07,
                  ),
                  IconButton(
                    onPressed: () async {
                      providerWOL.playBtn();
                    },
                    icon: Icon(
                      GetSongs.player.playing ? Icons.pause : Icons.play_arrow,
                    ),
                    color: Colors.white,
                    iconSize: width * 0.2,
                  ),
                  IconButton(
                    onPressed: () async {
                      providerWOL.nextBtn();
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.white,
                    iconSize: width * 0.07,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
