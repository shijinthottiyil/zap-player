import 'package:flutter/material.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/favourite_db.dart';
import 'package:zap_player/screens/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel>favoriteData, Widget? child) {
        return Scaffold(
          
          appBar: AppBar(
            title: Text('FAVORITE',style: TextStyle(color: Colors.white),),
            
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: ValueListenableBuilder(valueListenable: FavoriteDb.favoriteSongs, builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child){
            if(favoriteData.isEmpty){
              return Center(
                child: Text('NO FAVORITE SONGS',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              );
            } else{
              // if (!FavoriteDb.isInitialized) {
              //       FavoriteDb.intialize(favoriteData);
              //     }
              return ListView.separated(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    itemBuilder: ((ctx, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 10.0),
                        tileColor: Colors.white,
                        leading: QueryArtworkWidget(
                          id: favoriteData[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/images/default_music_logo.png',
                              )),
                        ),
                        title: Text(
                          favoriteData[index].title.toUpperCase(),
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        subtitle: Text(
                          maxLines: 1,
                          favoriteData[index].artist.toString() == '<unknown>'
                              ? 'UNKNOWN ARTIST'
                              : favoriteData[index].artist
                                  .toString()
                                  .toUpperCase(),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        onTap: () {
                          List<SongModel>favoriteList = [...favoriteData];
                          GetSongs.player.setAudioSource(
                              GetSongs.createSongList(favoriteList),
                              initialIndex: index);
                          GetSongs.player.play();
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return NowPlaying(
                              songModelList: favoriteList,
                           
                            );
                          })));
                        },
                        trailing: IconButton(onPressed: (() {
                          FavoriteDb.favoriteSongs.notifyListeners();
                                    FavoriteDb.delete(favoriteData[index].id);
                                    const snackbar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Song deleted from your favorites',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration: Duration(
                                        seconds: 1,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                        }), icon: Icon(Icons.delete)),
                      );
                    }),
                    
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                    itemCount: favoriteData.length);
            }
            
          },),
        );
      },
    );
  }
}