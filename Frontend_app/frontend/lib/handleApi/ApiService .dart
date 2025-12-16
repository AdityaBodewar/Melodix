import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://172.21.245.81:5000";


  static const String addMusicUrl = "$baseUrl/addmusic";
  static const String getMusicUrl = "$baseUrl/getallmusic";
  static const String searchMusicUrl = "$baseUrl/searchmusic";


  static const String registerUserUrl = "$baseUrl/registeruser";
  static const String registerArtistUrl = "$baseUrl/registerArtist";
  static const String loginUrl = "$baseUrl/login_flutter";



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


  static Future<List<dynamic>> fetchAllArtists() async {
    Dio dio = Dio();

    try {
      final res = await dio.get("$baseUrl/getallartist");

      if (res.statusCode == 200) {
        return res.data["artist"] ?? [];
      }
    } catch (e) {
      print("Fetch artist error: $e");
    }

    return [];
  }


  static Future<List<dynamic>> fetchSongsOfArtist(String artistId) async {
    Dio dio = Dio();

    try {
      final res = await dio.get("$baseUrl/getsongofartist/$artistId");

      if (res.statusCode == 200) {
        return res.data["data"] ?? [];
      }
    } catch (e) {
      print("Fetch artist songs error: $e");
    }

    return [];
  }





}

