import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ==================== BASE URL =====================
  static const String baseUrl = "http://172.21.245.81:5000";

  // ==================== MUSIC APIS ====================
  static const String addMusicUrl = "$baseUrl/addmusic";
  static const String getMusicUrl = "$baseUrl/getallmusic";
  static const String searchMusicUrl = "$baseUrl/searchmusic";

  // ==================== USER & AUTH ====================
  static const String registerUserUrl = "$baseUrl/registeruser";
  static const String registerArtistUrl = "$baseUrl/registerArtist";
  static const String loginUrl = "$baseUrl/login_flutter";

  // NEW PROFILE UPDATE API
  static const String updateProfileUrl = "$baseUrl/update_profile";

  // ======================================================
  // 🔥 UPLOAD MUSIC (ADMIN)
  // ======================================================
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
        addMusicUrl,
        data: formData,
        onSendProgress: onProgress,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }

  // ======================================================
  // 🔥 FETCH ALL MUSIC
  // ======================================================
  static Future<List<dynamic>> fetchAllMusic() async {
    Dio dio = Dio();

    try {
      Response response = await dio.get(getMusicUrl);

      if (response.statusCode == 200) {
        return response.data["data"];
      }
    } catch (e) {
      print("Error fetching songs: $e");
    }
    return [];
  }

  // ======================================================
  // 🔥 SEARCH MUSIC
  // ======================================================
  static Future<List<dynamic>> searchMusic(String query) async {
    Dio dio = Dio();

    try {
      Response response = await dio.post(
        searchMusicUrl,
        data: {"Title": query},
      );

      if (response.statusCode == 200) {
        return response.data["data"];
      }
    } catch (e) {
      print("Search error: $e");
    }

    return [];
  }

  // ======================================================
  // 🔥 REGISTER USER
  // ======================================================
  static Future<Map<String, dynamic>> registerUser({
    required String fullname,
    required String username,
    required String email,
    required String password,
  }) async {
    Dio dio = Dio();

    try {
      Response res = await dio.post(
        registerUserUrl,
        data: {
          "Fullname": fullname,
          "Username": username,
          "Email": email,
          "Password": password,
        },
      );

      return res.data;
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // ======================================================
  // 🔥 REGISTER ARTIST
  // ======================================================
  static Future<Map<String, dynamic>> registerArtist({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String type,
  }) async {
    Dio dio = Dio();

    try {
      Response res = await dio.post(
        registerArtistUrl,
        data: {
          "Fullname": fullname,
          "Username": username,
          "Email": email,
          "Password": password,
          "Type": type,
        },
      );

      return res.data;
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // ======================================================
  // 🔥 LOGIN
  // ======================================================
  static Future<Map<String, dynamic>> login_flutter({
    required String email,
    required String password,
  }) async {
    Dio dio = Dio();

    try {
      Response res = await dio.post(
        loginUrl,
        data: {
          "Email": email,
          "Password": password,
        },
        options: Options(validateStatus: (_) => true),
      );

      return {
        "status": res.statusCode,
        "data": res.data,
      };
    } catch (e) {
      return {
        "status": 500,
        "data": {"error": "Network error"}
      };
    }
  }

  // ======================================================
  // 🔥 UPDATE PROFILE (Fullname + Email + Image)
  // ======================================================
  static Future<Map<String, dynamic>> updateProfile({
    required String oldEmail,
    required String fullname,
    required String newEmail,
    required String role,
    String? imagePath,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse(updateProfileUrl));

    request.fields["OldEmail"] = oldEmail;
    request.fields["Fullname"] = fullname;
    request.fields["NewEmail"] = newEmail;
    request.fields["Role"] = role;

    if (imagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath("Image", imagePath),
      );
    }

    var response = await request.send();
    var body = await response.stream.bytesToString();

    return {
      "status": response.statusCode,
      "data": json.decode(body),
    };
  }

}
