import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/favourite_db.dart';

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
    const PlaylistScreen(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectIndex],
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder: (BuildContext context, List<SongModel> music, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (GetSongs.player.currentIndex != null)
                Column(
                  children: const [
                    MiniPlayer(),
                  ],
                )
              else
                const SizedBox(),
              SizedBox(
                height: 75,
                child: BottomNavigationBar(
                  backgroundColor: Colors.black,
                  showUnselectedLabels: false,
                  selectedFontSize: 10.0,
                  // selectedIconTheme: IconThemeData(
                  //   size: 40.0,
                  // ),
                  selectedItemColor: Colors.white,
                  selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  currentIndex: selectIndex,
                  onTap: (value) {
                    setState(
                      () {
                        selectIndex = value;
                      },
                    );
                  },
                  items: <BottomNavigationBarItem>[
                    bottomNavBarMethod(
                        bottomNavBarIcon: Icons.home,
                        bottomNavBarLabel: 'HOME'),
                    bottomNavBarMethod(
                        bottomNavBarIcon: Icons.playlist_add_check_rounded,
                        bottomNavBarLabel: 'PLAYLIST'),
                    bottomNavBarMethod(
                        bottomNavBarIcon: Icons.settings,
                        bottomNavBarLabel: 'SETTINGS'),
                  ],
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
