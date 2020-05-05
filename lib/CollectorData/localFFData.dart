import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalFF {
  static final specieData = Firestore.instance.collection('MainData');

  static Future<String> get _localPath async {
    final dir = await getTemporaryDirectory();
    print("hm ${dir.path}");
    return dir.path;
  }

  static Future<void> init() async {
    final path = await _localPath;
    final ffFile = File('$path/MainData.txt');
    if (await ffFile.exists()) {
      print("ya");
    } else {
      print("na");
    }
  }
}
