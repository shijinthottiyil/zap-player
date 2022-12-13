import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zap_player/db/functions/playlist_db.dart';
import 'package:zap_player/db/model/music_model.dart';
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
        return SafeArea(
          child: Scaffold(
            body: Hive.box<MusicModel>('playlistDB').isEmpty
                ? const Center(
                    child: Text(
                      'NO PLAYLIST',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02),
                    itemBuilder: ((BuildContext context, int index) {
                      final data = musicList.values.toList()[index];
                      return ListTile(
                        leading: Image.asset(
                            'assets/images/music-playlist-icon-19.jpg'),
                        title: Text(
                          data.name,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: const Text(
                                    '!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: const Text(
                                    'Do you really want to delete this playlist?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: [
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
                                        musicList.deleteAt(index);
                                        Navigator.pop(context);
                                      }),
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                  backgroundColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.05),
                                  ),
                                );
                              }),
                            );
                          },
                          icon: const Icon(
                            Icons.close,
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
                      return const Divider(
                        color: Colors.white,
                      );
                    }),
                    itemCount: musicList.length),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: (() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      elevation: 0.0,
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Create New Playlist',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                controller: nameController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.1),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    if (_formKey.currentState!.validate()) {
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
              child: const Icon(Icons.add),
            ),
          ),
        );
      }),
    );
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
