import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserName {
  static String name;
  static bool isLoggedin;
  static String randVal;
  static setter(String temp) {
    name = temp;
    isLoggedin = true;
  }

  static Future<String> get localPath async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  static Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/userData.txt');
  }

  static Future<File> writeIn(String encr) async {
    randVal = encr;
    final file = await _localFile;
    return file.writeAsString(
        'uid: $name \nstatus: $isLoggedin \nrandVal: $encr',
        mode: FileMode.write);
  }

  static Future<int> checker() async {
    final file = await _localFile;
    if (await file.exists() == true) {
      final contents = file.readAsStringSync();
      randVal = contents.substring(contents.indexOf("randVal: ") + 9);
      print("randVal offline : $randVal");
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
