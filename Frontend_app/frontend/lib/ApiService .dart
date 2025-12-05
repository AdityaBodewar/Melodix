import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String url = "http://10.88.17.81:5000/addmusic";


  static Future<bool> uploadMusic({
    required String title,
    required String singer,
    required String language,
    required String type,
    required File image,
    required File audio,
  }) async {

    var request = http.MultipartRequest("POST", Uri.parse(url));

    // JSON fields
    request.fields["title"] = title;
    request.fields["singer"] = singer;
    request.fields["language"] = language;
    request.fields["type"] = type;

    // Attach image
    request.files.add(
      await http.MultipartFile.fromPath("image", image.path),
    );

    // Attach audio
    request.files.add(
      await http.MultipartFile.fromPath("audio", audio.path),
    );

    var response = await request.send();
    return response.statusCode == 200;
  }
}