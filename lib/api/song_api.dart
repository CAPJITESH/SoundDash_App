import 'package:http/http.dart';
import 'dart:convert';

class Api {
  static Future<Map<String, dynamic>> fetchApiResponse(String endpoint) async {
    final response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch API response');
    }
  }

  static Future<List<Map<String, dynamic>>> getReco(String pid) async {
    final apiUrl =
        "https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&__call=reco.getreco&pid=$pid";

    final response = await get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final mapsList = jsonResponse;

      List<Map<String, dynamic>> responses = [];

      for (var map in mapsList) {
        final permaUrl = map['perma_url'];

        final url = 'https://saavn.me/songs?link=$permaUrl';
        final urlResponse = await get(Uri.parse(url));

        if (urlResponse.statusCode == 200) {
          final urlJsonResponse = json.decode(urlResponse.body);
          responses.add(urlJsonResponse);
        }
      }

      return responses;
    } else {
      throw Exception('Failed to fetch Data from the API');
    }
  }

  static Future<Map<String, dynamic>> getAlbum(String link) async {
    final endpoint = "https://saavn.me/albums?link=$link";

    final response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch API response');
    }
  }

  static Future<Map<String, dynamic>> getPlaylist(String id) async {
    final endpoint = "https://saavn.me/playlists?id=$id";

    final response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch API response');
    }
  }
}

class HomeDataFetcher {
  Future<Map<String, dynamic>> formatHomeData(Map<String, dynamic> data) async {
    Map<String, dynamic> temp = {};
    for (var i in data['modules'].keys) {

      String title = data['modules'][i]['title'];
      List<dynamic> value = data[i];
      temp[title] = value;
    }
    // print(temp);
    return temp;
  }

  Future<Map<String, dynamic>> fetchData() async {
    var url = Uri.parse(
        'https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&__call=webapi.getLaunchData');

    String languageHeader = 'L=english%2Chindi';
    Map<String, String> headers = {'cookie': languageHeader, 'Accept': '*/*'};

    final response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // print(responseBody);
      final result = await formatHomeData(responseBody);
      return result;
    } else {
      throw Exception('Failed to fetch API response');
    }
  }
}
