import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../CollectorData/CollectorData.dart';

class LocalFF {
  static var checker = 0;
  static Future<String> get localPath async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  static Future<void> init() async {
    final specieData = Firestore.instance.collection('MainData');
    final floraDat = await specieData.document('FloraSpecies').get();
    final faunaDat = await specieData.document('FaunaSpecies').get();
    final disturbanceDat = await specieData.document('disturbance').get();
    final path = await localPath;
    final floraFile = File('$path/floraDat.txt');
    final faunaFile = File('$path/faunaDat.txt');
    final disFile = File('$path/disturbanceDat.txt');

    for (var i = 0; i < CollectorData.subTypeFlora.length; i++) {
      floraFile.writeAsStringSync("${CollectorData.subTypeFlora[i]}\n",
          mode: FileMode.append);
      floraFile.writeAsStringSync(
          "${(floraDat[CollectorData.subTypeFlora[i]]).toString()}\n",
          mode: FileMode.append);
    }
    for (var i = 0; i < CollectorData.subTypeFauna.length; i++) {
      faunaFile.writeAsStringSync("${CollectorData.subTypeFauna[i]}\n",
          mode: FileMode.append);
      faunaFile.writeAsStringSync(
          "${(faunaDat[CollectorData.subTypeFauna[i]]).toString()}\n",
          mode: FileMode.append);
    }
    for (var i = 0; i < CollectorData.subTypeDisturbance.length; i++) {
      disFile.writeAsStringSync("${CollectorData.subTypeDisturbance[i]}\n",
          mode: FileMode.append);
      disFile.writeAsStringSync(
          "${(disturbanceDat[CollectorData.subTypeDisturbance[i]]).toString()}\n",
          mode: FileMode.append);
    }
    print("yayayayaya");
  }
}
