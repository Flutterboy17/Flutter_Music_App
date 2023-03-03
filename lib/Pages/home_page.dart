// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/Constants/colors.dart';
import 'package:flutter_music_player_app/Constants/styles.dart';
import 'package:flutter_music_player_app/Controllers/player_controller.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'player.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: primaryColor,
                ))
          ],
          leading: Icon(
            Icons.sort_rounded,
            color: primaryColor,
          ),
          title: Text("Beats", style: styles(size: 18)),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No songs found!",
                  style: styles(),
                ),
              );
            }
            else {
              //print(snapshot.data);
              return Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      // clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(bottom: 4),
                      // decoration:
                      //     BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: Obx(
                        () => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          tileColor: bgColor,
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Icon(Icons.music_note,
                                color: primaryColor, size: 32),
                          ),
                          onTap: () {
                            Get.to(() => Player(data: snapshot.data!,));
                            // controller.playSong(snapshot.data![index].uri, index);
                          },
                          trailing: Icon(
                            controller.playIndex.value == index &&
                                    controller.isPlaying.value
                                ? Icons.play_arrow
                                : null,
                            color: primaryColor,
                            size: 26,
                          ),
                          title: Text(
                            " ${snapshot.data![index].displayNameWOExt}",
                            style: styles(size: 15),
                          ),
                          subtitle: Text(
                            " ${snapshot.data![index].artist}",
                            style: styles(size: 12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
