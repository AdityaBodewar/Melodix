import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  static const String url = "http://172.21.245.81:5000/addmusic";

  static Future<bool> uploadMusic({
    required String title,
    required String singer,
    required String language,
    required String type,
    required File image,
    required File audio,
    required Function(int sent, int total) onProgress,
  }) async {
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      "title": title,
      "singer": singer,
      "language": language,
      "type": type,
      "image": await MultipartFile.fromFile(image.path),
      "audio": await MultipartFile.fromFile(audio.path),
    });

    try {
      Response response = await dio.post(
        url,
        data: formData,
        onSendProgress: (sent, total) {
          onProgress(sent, total); // Percentage will be exact ✔
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // get all music from backend

  static const String getMusicUrl = "http://172.21.245.81:5000/getallmusic";

  static Future<List<dynamic>> fetchAllMusic() async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(getMusicUrl);

      if (response.statusCode == 200) {
        return response.data["data"];  // list of songs
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching songs: $e");
      return [];
    }
  }

  static const String searchUrl = "http://172.21.245.81:5000/searchmusic";

  static Future<List<dynamic>> searchMusic(String query) async{
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        searchUrl,
        data: {
          "Title": query,  // backend ko Title chahiye
        },
      );

      if (response.statusCode == 200) {
        return response.data["data"]; // matched songs list
      } else {
        return [];
      }
  }catch (e) {
      print("Error searching songs: $e");
      return [];
    }
  }


}
