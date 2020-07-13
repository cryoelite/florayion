import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'GetLocalCollection.dart';

class SetLocalCollection {
  static var checker = 0;
  static Future<String> get localPath async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  static Future<void> init() async {
    final GetLocalCollection colDat = GetLocalCollection();
    final specieData = Firestore.instance.collection('MainData');
    final floraDat = await specieData.document('FloraSpecies').get();
    final faunaDat = await specieData.document('FaunaSpecies').get();
    final disturbanceDat = await specieData.document('disturbance').get();
    final path = await localPath;
    final floraFile = File('$path/floraDat.txt');
    final faunaFile = File('$path/faunaDat.txt');
    final disFile = File('$path/disturbanceDat.txt');
    for (var i = 0; i < colDat.subTypeFlora.length; i++) {
      floraFile.writeAsStringSync("${colDat.subTypeFlora[i]}\n",
          mode: FileMode.append);
      floraFile.writeAsStringSync(
          "${(floraDat[colDat.subTypeFlora[i]]).toString()}\n",
          mode: FileMode.append);
    }
    for (var i = 0; i < colDat.subTypeFauna.length; i++) {
      faunaFile.writeAsStringSync("${colDat.subTypeFauna[i]}\n",
          mode: FileMode.append);
      faunaFile.writeAsStringSync(
          "${(faunaDat[colDat.subTypeFauna[i]]).toString()}\n",
          mode: FileMode.append);
    }
    for (var i = 0; i < colDat.subTypeDisturbance.length; i++) {
      disFile.writeAsStringSync("${colDat.subTypeDisturbance[i]}\n",
          mode: FileMode.append);
      disFile.writeAsStringSync(
          "${(disturbanceDat[colDat.subTypeDisturbance[i]]).toString()}\n",
          mode: FileMode.append);
    }
    print("Set Local Collection Done.");
  }
}
