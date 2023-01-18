import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/view/screens/now_playing_screen.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/provider_miniplayer.dart';
import '../widgets/widget_icon.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('miniPlayerbuilds');
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<ProviderMiniPlayer>(
          context,
          listen: false,
        ).mountedFun();
      },
    );
    return Consumer<ProviderMiniPlayer>(
      builder: (context, value, child) {
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
                    : GetSongs
                        .playingSongs[GetSongs.player.currentIndex!].artist
                        .toString(),
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 11,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: [
                  IconButton(
                    onPressed: Provider.of<ProviderMiniPlayer>(
                      context,
                      listen: false,
                    ).previousBtnPressed,
                    icon: const WidgetIcon(
                      icon: Icons.skip_previous_sharp,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      Provider.of<ProviderMiniPlayer>(
                        context,
                        listen: false,
                      ).playBtnPressed(context);
                    },
                    child: StreamBuilder<bool>(
                      stream: GetSongs.player.playingStream,
                      builder: (context, snapshot) {
                        bool? playingStage = snapshot.data;
                        if (playingStage != null && playingStage) {
                          return const WidgetIcon(
                            icon: Icons.pause,
                          );
                        } else {
                          return const WidgetIcon(
                            icon: Icons.play_arrow,
                          );
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed:
                        Provider.of<ProviderMiniPlayer>(context).nextBtnPressed,
                    icon: const WidgetIcon(
                      icon: Icons.skip_next_sharp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
