import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zap_player/db/functions/playlist_db.dart';
import 'package:zap_player/db/model/music_model.dart';
import 'package:zap_player/screens/favorites/favourites_screen.dart';
import 'package:zap_player/screens/playlist/playlist_song_display.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return ValueListenableBuilder(
        valueListenable: Hive.box<MusicModel>('playlistDB').listenable(),
        builder:
            ((BuildContext context, Box<MusicModel> musicList, Widget? child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text(
                  'PLAYLIST',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    onPressed: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return const FavoriteScreen();
                          }),
                        ),
                      );
                    }),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: (() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 0.0,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              height: 200.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Create New Playlist',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.red,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter playlist name";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: (() {
                                          Navigator.pop(context);
                                        }),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: (() {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            whenButtonClicked();
                                            Navigator.pop(context);
                                          }
                                        }),
                                        icon: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              body: Hive.box<MusicModel>('playlistDB').isEmpty
                  ? const Center(
                      child: Text(
                        'Press + To Create Playlist',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(15.0),
                      itemBuilder: ((BuildContext context, int index) {
                        final data = musicList.values.toList()[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.0,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: Text(
                            data.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              musicList.deleteAt(index);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((BuildContext context) {
                                  return PlaylistSongDisplayScreen(
                                    playlist: data,
                                    folderindex: index,
                                  );
                                }),
                              ),
                            );
                          },
                        );
                      }),
                      separatorBuilder: ((BuildContext context, int index) {
                        return SizedBox(
                          height: 20.0,
                        );
                      }),
                      itemCount: musicList.length));
        }));
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicModel(
        songId: [],
        name: name,
      );
      PlayListDB.playlistAdd(music);
      nameController.clear();
    }
  }
}
