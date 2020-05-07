import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalFF {
  

  static Future<String> get _localPath async {
    final dir = await getTemporaryDirectory();
    print("hm ${dir.path}");
    return dir.path;
  }

  static Future<void> init() async {
    final specieData = Firestore.instance.collection('MainData');
    final floraDat = await specieData.document('FloraSpecies').get();
    final faunaDat = await specieData.document('FaunaSpecies').get();
    final path = await _localPath;
    final floraFile = File('$path/floraDat.txt');
    if (await floraFile.exists()) {
      print("ya");
      print(floraFile.readAsStringSync());
    } else {
      floraFile.writeAsStringSync((floraDat.data).toString());
      print("na");
    }
  }
}
