import 'dart:developer';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  @override
  void onInit() {
    checkPermission();

    super.onInit();
  }

  changeSlider(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  updatePosition() {
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split(".")[0];
      max.value = event!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((event) {
      position.value = event.toString().split(".")[0];
      value.value = event.inSeconds.toDouble();
    });
  }

  playsSong(String? url, index) {
    playIndex.value = index;

    // check if index is out of bounds
    if (index < 0 || index >= url!.length) {
      index = 0; // set index to first song
    }
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url!)));
      audioPlayer.play();

      isPlaying(true);

      // listen for audio completion
      audioPlayer.playerStateStream.listen((event) {
        if (event.playing &&
            event.processingState == ProcessingState.completed) {
          // increment playIndex value
          playIndex.value++;

          // check if playIndex is out of bounds
          if (playIndex.value >= index.length) {
            playIndex.value = 0; // set playIndex to first song
          }

          // play the next song
          playsSong(index, playIndex.value);
        }
      });

      updatePosition();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }
}
