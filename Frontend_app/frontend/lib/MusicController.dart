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

  static bool userPaused = false;

  static Future<void> configureAudioSession() async {
    await player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,

          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );

    player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        isPlaying = true;
      } else {
        isPlaying = false;
      }
    });
  }

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

    userPaused = false;
    isPlaying = true;
  }

  static Future<void> togglePlayPause() async {
    if (player.state == PlayerState.playing) {
      await player.pause();
      userPaused = true;
      isPlaying = false;
    } else {
      await player.resume();
      userPaused = false;
      isPlaying = true;
    }
  }

  static Future<void> stopOnlineSong() async {
    await player.stop();
    isPlaying = false;
    userPaused = false;
  }

  static Future<void> reset() async {
    await player.stop();

    title = null;
    singer = null;
    image = null;

    isOffline = false;
    localFilePath = null;

    currentIndex = null;
    currentList = null;

    isPlaying = false;
    userPaused = false;
  }
}
