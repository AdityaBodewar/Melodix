// bottom navigation song

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicController {
  static final AudioPlayer player = AudioPlayer();

  static String? title;
  static String? singer;
  static String? image;

  static int? currentIndex;             // ⭐ new
  static List? currentList;             // ⭐ new

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

    currentIndex = index;   // ⭐
    currentList = songList; // ⭐

    isPlaying = true;
  }

  static void togglePlayPause() {
    isPlaying = !isPlaying;
    onPlayPausePressed?.call();
  }
}
