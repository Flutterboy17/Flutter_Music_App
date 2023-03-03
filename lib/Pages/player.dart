import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/Constants/colors.dart';
import 'package:flutter_music_player_app/Constants/styles.dart';
import 'package:flutter_music_player_app/Controllers/player_controller.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  const Player({super.key, required this.data});

  final List<SongModel> data;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Obx(()=>
         Column(
            children: [
              Obx(()=>
                 Expanded(
                    child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        alignment: Alignment.center,
                        child: QueryArtworkWidget(
                          id: data[controller.playIndex.value].id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: double.infinity,
                          artworkWidth: double.infinity,
                        ))),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Column(
                  children: [
                    Text(data[controller.playIndex.value].displayNameWOExt,
                        style: styles(
                          size: 20,
                          color: scaffoldColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      data[controller.playIndex.value].artist.toString(),
                      style: styles(size: 18, color: scaffoldColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.position.value,
                            style: styles(color: scaffoldColor),
                          ),
                          Expanded(
                              child: Slider(
                                  inactiveColor: bgColor,
                                  activeColor: secondaryColor,
                                  thumbColor: scaffoldColor,
                                  value: controller.value.value,
                                  min: Duration(seconds: 0).inSeconds.toDouble(),
                                  max: controller.max.value,
                                  onChanged: (value) {
                                    controller.changeSlider(value.toInt());
                                    value = value;
                                  })),
                          Text(
                            controller.duration.value,
                            style: styles(color: scaffoldColor),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.playsSong(
                                  data[controller.playIndex.value].uri,
                                  controller.playIndex.value-1);
                            },
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: bgColor,
                            )),
                        Obx(
                          () => CircleAvatar(
                              radius: 35,
                              backgroundColor: bgColor,
                              child: Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      onPressed: () {
                                        if (controller.isPlaying.value) {
                                          controller.audioPlayer.pause();
                                          controller.isPlaying(false);
                                        } else {
                                          controller.audioPlayer.play();
                                          controller.isPlaying(true);
                                        }
                                      },
                                      icon: controller.isPlaying.value
                                          ? Icon(
                                              Icons.pause_rounded,
                                              color: primaryColor,
                                            )
                                          : Icon(
                                              Icons.play_arrow_rounded,
                                              color: primaryColor,
                                            )))),
                        ),
                        IconButton(
                            onPressed: () {
                                controller.playsSong(
                                  data[controller.playIndex.value+1].uri,
                                  controller.playIndex.value + 1);
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: bgColor,
                            )),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
