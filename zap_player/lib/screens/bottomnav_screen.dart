import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/screens/favorites/favourites_screen.dart';

import 'package:zap_player/screens/home_screen.dart';
import 'package:zap_player/screens/miniplayer.dart';
import 'package:zap_player/screens/playlist/playlist_screen.dart';
import 'package:zap_player/screens/settings_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const FavoriteScreen(),
    const PlaylistScreen(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[selectIndex],
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder: (BuildContext context, List<SongModel> music, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetSongs.player.currentIndex != null
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.085,
                      child: const MiniPlayer(),
                    )
                  : const SizedBox(),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.lightBlue,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.085,
                  child: BottomNavigationBar(
                    elevation: 0.0,
                    showUnselectedLabels: false,
                    selectedFontSize: MediaQuery.of(context).size.height * 0.01,
                    selectedItemColor: Colors.white,
                    selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    currentIndex: selectIndex,
                    onTap: (value) {
                      setState(
                        () {
                          selectIndex = value;
                          FavoriteDb.favoriteSongs.notifyListeners();
                        },
                      );
                    },
                    items: <BottomNavigationBarItem>[
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.home,
                          bottomNavBarLabel: 'HOME'),
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.favorite,
                          bottomNavBarLabel: 'FAVORITE'),
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.playlist_add_check_rounded,
                          bottomNavBarLabel: 'PLAYLIST'),
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.settings,
                          bottomNavBarLabel: 'SETTINGS'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem bottomNavBarMethod(
      {required IconData bottomNavBarIcon, required String bottomNavBarLabel}) {
    return BottomNavigationBarItem(
        icon: Icon(
          bottomNavBarIcon,
          color: Colors.white,
        ),
        label: bottomNavBarLabel);
  }
}
