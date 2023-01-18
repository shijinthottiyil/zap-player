import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/view/screens/favorites/favourites_screen.dart';
import 'package:zap_player/view/screens/home_screen.dart';
import 'package:zap_player/view/screens/miniplayer.dart';
import 'package:zap_player/view/screens/playlist/playlist_screen.dart';
import 'package:zap_player/view/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/provider_bottom_nav.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final List<Widget> pages = [
    HomePage(),
    const FavoriteScreen(),
    PlaylistScreen(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final providerBottomnav = Provider.of<ProviderBottomNav>(context);
    return Scaffold(
      extendBody: true,
      body: pages[providerBottomnav.selectIndex],
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder: (BuildContext context, List<SongModel> music, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetSongs.player.currentIndex != null
                  ? SizedBox(
                      height: height * 0.085,
                      child: const MiniPlayer(),
                    )
                  : const SizedBox(),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: SizedBox(
                  height: height * 0.085,
                  child: BottomNavigationBar(
                    showUnselectedLabels: false,
                    unselectedItemColor: Colors.white,
                    selectedFontSize: height * 0.01,
                    selectedItemColor: Colors.red,
                    selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    currentIndex: providerBottomnav.selectIndex,
                    onTap: (value) {
                      Provider.of<ProviderBottomNav>(
                        context,
                        listen: false,
                      ).onTapFn(value);
                    },
                    items: <BottomNavigationBarItem>[
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.home,
                          bottomNavBarLabel: 'HOME'),
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.favorite,
                          bottomNavBarLabel: 'FAVORITE'),
                      bottomNavBarMethod(
                          bottomNavBarIcon: Icons.queue_music,
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
        ),
        label: bottomNavBarLabel);
  }
}
