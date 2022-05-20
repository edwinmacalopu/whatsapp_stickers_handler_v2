import 'dart:convert';
import 'dart:io';

import '../main.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> localFile(String fileName) async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  static Future<Map<String, dynamic>> fetchDataAndWriteFile(File file) async {
    Dio dio = Dio();
    var response =
        await dio.get("${constants.baseUrl}${constants.remoteFileName}");
    file.writeAsString(response.toString());
    return json.decode(response.toString()) as Map<String, dynamic>;
  }
}
