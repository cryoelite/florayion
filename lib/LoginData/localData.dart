import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserName {
  static String name;
  static bool isLoggedin;
  static setter(String temp) {
    name = temp;
    isLoggedin = true;
    writeIn();
  }

  static Future<String> get _localPath async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userData.txt');
  }

  static Future<File> writeIn() async {
    final file = await _localFile;
    return file.writeAsString('uid: $name \nstatus: $isLoggedin');
  }

  static Future<int> checker() async {
    final file = await _localFile;
    if (await file.exists() == true) {
      final contents = file.readAsStringSync();
      name = contents.substring(5, contents.indexOf("\n") - 1);
      if (contents[contents.indexOf("status:") + 8] == "t") {
        print(contents);
        isLoggedin = true;
        return 1;
      } else {
        isLoggedin = false;
        return 0;
      }
    } else {
      return 0;
    }
  }
}