import 'package:http/http.dart';
import 'dart:convert';
import 'package:pointycastle/export.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';
import 'package:dart_des/dart_des.dart';

class Api {
  // static Future<Map<String, dynamic>> fetchApiResponse(String endpoint) async {
  //   final response = await get(Uri.parse(endpoint));
  //   if (response.statusCode == 200) {
  //     final responseBody = json.decode(response.body);
  //     return responseBody as Map<String, dynamic>;
  //   } else {
  //     throw Exception('Failed to fetch API response');
  //   }
  // }

  static Future<Map<String, dynamic>> getSongDetails(String id) async {
    final endpoint = "https://saavn.me/songs?id=$id";

    final response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // print(responseBody);
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

  static String decryptDES(String encryptedBase64) {
    String key = '38346591';
    List<int> encrypted = base64.decode(encryptedBase64);
    List<int> decrypted;

    if (key.length == 8) {
      // Use DES
      List<int> iv = [0, 0, 0, 0, 0, 0, 0, 0];
      DES desECB = DES(key: key.codeUnits, mode: DESMode.ECB, iv: iv);
      decrypted = desECB.decrypt(encrypted);
    } else {
      throw ArgumentError(
          'Invalid key length. Key must be 8 or 24 bytes long.');
    }
    final link = utf8.decode(decrypted);
    // final modifiedLink = '$link\_320.mp4';
    // print(modifiedLink);
    return link;
  }

  static Future<Map<String, dynamic>> otherData(
      String id, String type, String language) async {
    if (type == 'radio_station') {
      final endpoint =
          "https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&__call=webradio.createFeaturedStation&name=$id&language=$language";

      final response = await get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // print(responseBody);
        // print(type);
        final stationID = responseBody['stationid'];
        final res = await get(Uri.parse(
            "https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&__call=webradio.getSong&stationid=$stationID&k=40&next=1"));

        if (res.statusCode == 200) {
          final resBody = json.decode(res.body);
          Map<String, dynamic> temp = formatter(resBody, type);

          return temp;
        } else {
          throw Exception('Failed to fetch API response of radio songs');
        }
      } else {
        throw Exception('Failed to fetch API response');
      }
    } else {
      final endpoint =
          "https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&token=$id&type=$type&__call=webapi.get";

      final response = await get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print(responseBody);
        print(type);
        Map<String, dynamic> temp = formatter(responseBody, type);

        return temp;
      } else {
        throw Exception('Failed to fetch API response');
      }
    }
  }

  static Map<String, dynamic> formatter(
      Map<String, dynamic> data, String type) {
    Map<String, dynamic> temp = {};

    if (type == "show") {
      temp['title'] = data['show_details']['title'];
      temp['image'] = data['show_details']['image'];

      // Create a list with three maps containing quality and link keys
      List<Map<String, dynamic>> tempSongs = List<Map<String, dynamic>>.from(
        (data['episodes'] as List).map((episode) {
          return {
            'id': episode['id'],
            'name': episode['title'],
            'primaryArtists': "Unknown",
            'album': {'name': "Unknown"},
            'image': List.generate(
                3,
                (index) => {
                      'quality': '120',
                      'link': episode['image'], // Replace with the actual URL
                    }),
            'downloadUrl': List.generate(
                5,
                (index) => {
                      'quality': '320',
                      'link': decryptDES(episode['more_info'][
                          'encrypted_media_url']), // Replace with the actual URL
                    }),
            // Add more keys as needed
          };
        }),
      );
      temp['data'] = {};
      temp['data']['songs'] = tempSongs;
    } else if (type == "mix") {
      temp['title'] = data['title'];
      temp['image'] = data['image'];

      // Create a list with three maps containing quality and link keys
      List<Map<String, dynamic>> tempSongs = List<Map<String, dynamic>>.from(
        (data['list'] as List).map((episode) {
          return {
            'id': episode['id'],
            'name': episode['title'],
            'primaryArtists': episode['subtitle'],
            'album': {'name': episode['more_info']['album']},
            'image': List.generate(
                3,
                (index) => {
                      'quality': '120',
                      'link': episode['image'], // Replace with the actual URL
                    }),
            'downloadUrl': List.generate(
                5,
                (index) => {
                      'quality': '320',
                      'link': decryptDES(episode['more_info'][
                          'encrypted_media_url']), // Replace with the actual URL
                    }),
            // Add more keys as needed
          };
        }),
      );
      temp['data'] = {};
      temp['data']['songs'] = tempSongs;
    } else if (type == 'radio_station') {
      List<Map<String, dynamic>> tempSongs = [];

      for (var e in data.entries) {
        Map<String, dynamic> t = {};
        t['id'] = e.value['id'];
        t['name'] = e.value['title'];
        String artistNames = '';

        try {
          if (e.value['more_info'] != null) {
            if (e.value['more_info']['artistMap'] != null) {
              e.value['more_info']['artistMap']['artists'].forEach((item) {
                artistNames += item['name'];
              });
            } else {
              artistNames = e.value['subtitle'];
            }
          }
        } catch (e) {
          artistNames = " ";
        }
        t['primaryArtists'] = artistNames;
        t['album'] = e.value['more_info']['album'];
        t['image'] = List.generate(
            3,
            (index) => {
                  'quality': '120',
                  'link': e.value['image'], // Replace with the actual URL
                });
        t['downloadUrl'] = List.generate(
            5,
            (index) => {
                  'quality': '320',
                  'link': decryptDES(e.value['more_info']
                      ['encrypted_media_url']), // Replace with the actual URL
                });
        tempSongs.add(t);
      }
      temp['data'] = {};
      temp['data']['songs'] = tempSongs;
    }
    print(temp);
    print("YYYYYYYYYYYYYY");
    return temp;
  }

  static Future<Map<String, dynamic>> performSearch(String query) async {
    final endpoint =
        "https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&__call=autocomplete.get&cc=in&includeMetaTags=2&query=$query";

    final response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      Map<String, dynamic> temp = {};

      if (responseBody['topquery'] != null &&
          responseBody['topquery']['data'].length != 0) {
        temp['Top Searched'] = responseBody['topquery']['data'];
      }

      if (responseBody['songs'] != null &&
          responseBody['songs']['data'].length != 0) {
        temp['Songs'] = responseBody['songs']['data'];
      }
      if (responseBody['albums'] != null &&
          responseBody['albums']['data'].length != 0) {
        temp['Albums'] = responseBody['albums']['data'];
      }
      if (responseBody['playlists'] != null &&
          responseBody['playlists']['data'].length != 0) {
        temp['Playlists'] = responseBody['playlists']['data'];
      }
      if (responseBody['artists'] != null &&
          responseBody['artists']['data'].length != 0) {
        temp['Artists'] = responseBody['artists']['data'];
      }
      return temp;
    } else {
      throw Exception('Failed to fetch API response');
    }
  }

  static Future<String> getLyrics(Map<String, dynamic> songData) async {
    try {
      if (songData['hasLyrics'] == true) {
        int id = songData['id'];
        final Uri lyricsUrl = Uri.https(
          'www.jiosaavn.com',
          '/api.php?__call=lyrics.getLyrics&lyrics_id=$id&ctx=web6dot0&api_version=4&_format=json',
        );
        final Response res =
            await get(lyricsUrl, headers: {'Accept': 'application/json'});

        // print(res.body);

        final List<String> rawLyrics = res.body.split('-->');
        Map fetchedLyrics = {};
        if (rawLyrics.length > 1) {
          fetchedLyrics = json.decode(rawLyrics[1]) as Map;
        } else {
          fetchedLyrics = json.decode(rawLyrics[0]) as Map;
        }
        String lyrics =
            fetchedLyrics['lyrics'].toString().replaceAll('<br>', '\n');

        return lyrics;
      } else {
        String lyrics = await getMusixMatchLyrics(
            title: songData['name'],
            artist: songData['primaryArtists']) as String;
        return lyrics;
      }
    } catch (e) {
      print("this is the error : $e");
      return '';
    }
  }

  static Future<String> getLyricsLink(String song, String artist) async {
    const String authority = 'www.musixmatch.com';
    final String unencodedPath = '/search/$song $artist';
    final Response res = await get(Uri.https(authority, unencodedPath));
    if (res.statusCode != 200) return '';
    final RegExpMatch? result =
        RegExp(r'href=\"(\/lyrics\/.*?)\"').firstMatch(res.body);
    return result == null ? '' : result[1]!;
  }

  static Future<String> scrapLink(String unencodedPath) async {
    const String authority = 'www.musixmatch.com';
    final Response res = await get(Uri.https(authority, unencodedPath));
    if (res.statusCode != 200) return '';
    final List<String?> lyrics = RegExp(
      r'<span class=\"lyrics__content__ok\">(.*?)<\/span>',
      dotAll: true,
    ).allMatches(res.body).map((m) => m[1]).toList();

    return lyrics.isEmpty ? '' : lyrics.join('\n');
  }

  static Future<String> getMusixMatchLyrics({
    required String title,
    required String artist,
  }) async {
    try {
      final String link = await getLyricsLink(title, artist);
      final String lyrics = await scrapLink(link);
      return lyrics;
    } catch (e) {
      return '';
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
