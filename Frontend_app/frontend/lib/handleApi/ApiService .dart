import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  static const String url = "http://10.88.17.81:5000/addmusic";

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
}
