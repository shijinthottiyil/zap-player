import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:zap_player/db/model/music_model.dart';
import 'package:zap_player/view/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './controller/provider/provider_bottom_nav.dart';
import './controller/provider/provider_homescreen.dart';
import './controller/provider/provider_searchscreen.dart';
import './controller/provider/provider_nowplaying.dart';
import './controller/provider/provider_miniplayer.dart';
import './controller/provider/provider_favbut.dart';
import './controller/provider/provider_playlist_screen.dart';
import './controller/provider/provider_playlist_song_list.dart';
import './controller/provider/provider_splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }

  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusicModel>('playlistDB');

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    preloadArtwork: true,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProviderSplashScreen();
        }),
        ChangeNotifierProvider(
          create: ((context) {
            return ProviderBottomNav();
          }),
        ),
        ChangeNotifierProvider(
          create: ((context) {
            return ProviderHomeScreen();
          }),
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProviderSearchScreen();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProviderNowPlaying();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProviderMiniPlayer();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProviderFavBut();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProviderPlaylistScreen();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProviderPlaylistSongList();
          },
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    ),
  );
}
