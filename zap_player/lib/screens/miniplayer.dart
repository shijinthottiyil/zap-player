import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/screens/now_playing_screen.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListTile(
        tileColor: Colors.red,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NowPlaying(
                songModelList: GetSongs.playingSongs,
              ),
            ),
          );
        },
        textColor: const Color.fromARGB(255, 255, 255, 255),
        leading: QueryArtworkWidget(
          artworkQuality: FilterQuality.high,
          artworkFit: BoxFit.fill,
          artworkBorder: BorderRadius.circular(0),
          nullArtworkWidget: Image.asset(
            'assets/images/splash_screen_logo.png',
          ),
          id: GetSongs.playingSongs[GetSongs.player.currentIndex!].id,
          type: ArtworkType.AUDIO,
        ),
        title: Text(
          GetSongs.playingSongs[GetSongs.player.currentIndex!].title
              .toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            GetSongs.playingSongs[GetSongs.player.currentIndex!].artist
                        .toString() ==
                    '<unknown>'
                ? 'UNKNOWN'
                : GetSongs.playingSongs[GetSongs.player.currentIndex!].artist
                    .toString(),
            maxLines: 1,
            overflow: TextOverflow.fade,
            style:
                const TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis),
          ),
        ),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    if (GetSongs.player.hasPrevious) {
                      await GetSongs.player.seekToPrevious();
                      await GetSongs.player.play();
                    } else {
                      await GetSongs.player.play();
                    }
                  },
                  icon: Icon(
                    Icons.skip_previous_sharp,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.09,
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: const CircleBorder(),
                ),
                onPressed: () async {
                  if (GetSongs.player.playing) {
                    await GetSongs.player.pause();
                    setState(() {});
                  } else {
                    await GetSongs.player.play();
                    setState(() {});
                  }
                },
                child: StreamBuilder<bool>(
                  stream: GetSongs.player.playingStream,
                  builder: (context, snapshot) {
                    bool? playingStage = snapshot.data;
                    if (playingStage != null && playingStage) {
                      return Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.09,
                      );
                    } else {
                      return Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.09,
                      );
                    }
                  },
                ),
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
                  icon: Icon(
                    Icons.skip_next_sharp,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.09,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
