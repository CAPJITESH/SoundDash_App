
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';


class Download {
  // ignore: non_constant_identifier_names
  Future<String> download_song_mp3(
      Map<String, dynamic> songData, BuildContext context) async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        String title = songData['name'];
        FileDownloader.downloadFile(
            url: songData['downloadUrl'][4]['link'],
            name: '$title.mp3',
            onDownloadCompleted: (String path) async {
              print('FILE DOWNLOADED TO PATH: $path');


           // ignore: use_build_context_synchronously
              FloatingSnackBar(
                message: '$title is Downloaded',
                context: context,
                textColor: Colors.white,
                textStyle: const TextStyle(color: Colors.white),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: Colors.black,
              );

              return "Song $title is Downloaded";
            },
            onDownloadError: (String error) {
              print('DOWNLOAD ERROR: $error');

              FloatingSnackBar(
                message: 'There is some error in downloading...Try again later',
                context: context,
                textColor: Colors.white,
                textStyle: const TextStyle(color: Colors.white),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: Colors.black,
              );
              return "There is some error in downloading...Try again later";
            });
      } else {
        print('Permission denied');

// ignore: use_build_context_synchronously
        FloatingSnackBar(
          message: 'Storage Permission is Denied',
          context: context,
          textColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: Colors.black,
        );

        return "Storage Permission is Denied";
      }
    } catch (e) {
      print('Error downloading audio: $e');

      FloatingSnackBar(
        message: 'There is some error in downloading...Try again later',
        context: context,
        textColor: Colors.white,
        textStyle: const TextStyle(color: Colors.white),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: Colors.black,
      );

      return 'There is some error in downloading...Try again later';
    }

// ignore: use_build_context_synchronously
    // FloatingSnackBar(
    //   message: 'There is some error in downloading...Try again later',
    //   context: context,
    //   textColor: Colors.white,
    //   textStyle: const TextStyle(color: Colors.white),
    //   duration: const Duration(milliseconds: 4000),
    //   backgroundColor: Colors.black,
    // );

    return 'There is some error in downloading...Try again later';
  }

}
