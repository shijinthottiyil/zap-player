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

  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> {
 
List<SongModel> startSong = [];
 
  // int _selectedIndex = 0;
  Color whiteColor = Colors.white;

  // void _onItemTapped(int index){
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   if(index==1){
  //     Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
  //       return Playlist();
  //     })));
  //     // Playlist();
  //   }
  // }
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  final _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('ZAP PLAYER'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ));
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
      ),
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
                  valueColor: AlwaysStoppedAnimation(
                    Colors.red,
                  ),
                ),
              );
            } else if (item.data == null ) {
              return const Center(child: Text("No Songs Found"));
            } else {
              startSong = item.data!;
              if (!FavoriteDb.isInitialized ) {
                    FavoriteDb.intialize(item.data!);
                  
                  }
              
                  
              // return listView_widget(item);
              return ListView.separated(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                itemBuilder: ((context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.only(left: 10.0),
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
                          : item.data![index].artist.toString().toUpperCase(),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
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
                    trailing: FavoriteButton(songFavorite: startSong[index])
                  );
                }),
                separatorBuilder: (context, index) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                itemCount: item.data!.length);
            }
          })),
    );
  }
}
//   ListView listView_widget(AsyncSnapshot<List<SongModel>> item) {
//     return ListView.separated(
//                 padding: EdgeInsets.only(left: 10.0,right: 10.0),
//                 itemBuilder: ((context, index) {
//                   return ListTile(
//                     contentPadding: EdgeInsets.only(left: 10.0),
//                     tileColor: whiteColor,
//                     leading: QueryArtworkWidget(
                      
//                       id: item.data![index].id,
//                       type: ArtworkType.AUDIO,
//                       nullArtworkWidget: CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           child: Image.asset(
//                             'assets/images/default_music_logo.png',
//                           )),
//                     ),
//                     title: Text(
//                       item.data![index].title.toUpperCase(),
//                       maxLines: 1,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.fade,
//                       ),
//                     ),
//                     subtitle: Text(
//                       maxLines: 1,
//                       item.data![index].artist.toString() == '<unknown>'
//                           ? 'UNKNOWN ARTIST'
//                           : item.data![index].artist.toString().toUpperCase(),
//                     ),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40.0)),
//                     onTap: () {
//                       GetSongs.player.setAudioSource(
//                           GetSongs.createSongList(item.data!),
//                           initialIndex: index);
//                       GetSongs.player.play();
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: ((context) {
//                         return NowPlaying(
//                           songModelList: item.data!,
//                         );
//                       })));
//                     },
//                     trailing: FavoriteButton(songFavorite: startSong[index])
//                   );
//                 }),
//                 separatorBuilder: (context, index) => SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.01,
//                     ),
//                 itemCount: item.data!.length);
//   }
// }
