import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:provider/provider.dart';

import '../widgets/widget_listview.dart';
import '../../controller/provider/provider_homescreen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static List<SongModel> startSong = [];
  final _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final providerWOL = Provider.of<ProviderHomeScreen>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (tiemStamp) {
        Provider.of<ProviderHomeScreen>(
          context,
          listen: false,
        ).requestPermission();
      },
    );
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              expandedHeight: height * 0.12,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'ZAP PLAYER',
                  style: TextStyle(
                    fontSize: width * 0.04,
                  ),
                ),
              ),
              pinned: true,
              actions: [
                IconButton(
                  onPressed: (() {
                    providerWOL.gotoSearch(context);
                  }),
                  icon: const Icon(
                    Icons.search,
                  ),
                )
              ],
            )
          ];
        }),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              HomePage.startSong = item.data!;
              GetSongs.songscopy = item.data!;

              if (!FavoriteDb.isInitialized) {
                FavoriteDb.intialize(item.data!);
              }
              return WidgetListViewSeparated(
                itemCount: item.data!.length,
                songModelList: item.data!,
              );
            }
          }),
        ),
      ),
    );
  }
}
