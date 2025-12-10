// bottom navigation song

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicController {
  static final AudioPlayer player = AudioPlayer();

  static String? title;
  static String? singer;
  static String? image;

  static bool isOffline = false;
  static String? localFilePath;


  static int? currentIndex;
  static List? currentList;

  static bool isPlaying = false;
  static Function()? onPlayPausePressed;

  static void updateSong({
    required String newTitle,
    required String newSinger,
    required String newImage,
    required int index,
    required List songList,
  }) {
    title = newTitle;
    singer = newSinger;
    image = newImage;

    currentIndex = index;
    currentList = songList;

    isPlaying = true;
  }

  static Future<void> togglePlayPause() async {
    if (player.state == PlayerState.playing) {
      await player.pause();
      isPlaying = false;
    } else {
      await player.resume();
      isPlaying = true;
    }

    // notify all listeners
    onPlayPausePressed?.call();
  }

  static Future<void> stopOnlineSong() async {
    await player.stop();
    isPlaying = false;
  }


}
