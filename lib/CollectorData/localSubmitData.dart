import 'dart:io';
import 'package:geolocator/geolocator.dart';

import '../LoginData/localData.dart';

class LocalSubmission {
  int id = 0;
  final String tempff;
  final String tempSubSpecie;
  final String tempSubmitVal;
  LocalSubmission(this.tempSubSpecie, this.tempff, this.tempSubmitVal);
  Future<void> submission() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final path = await UserName.localPath;
    File localDat = File('$path/submission.txt');
    if (localDat.existsSync()) {
      final info = localDat.readAsStringSync();
      final currentId = int.tryParse(
        info.substring(
          info.lastIndexOf("id=") + 3,
          info.indexOf(
            "\n",
          ),
        ),
      );
      print("Current ID: $currentId");
      localDat.writeAsStringSync(
        "id=${(currentId + 1).toString()}\n FF=$tempff\n SubSpecie=$tempSubSpecie\n SubmitVal=$tempSubmitVal\n Position=${(pos.toJson()).toString()}\n ",
      );
    } else {
      localDat.writeAsStringSync(
        "id=0\n FF=$tempff\n SubSpecie=$tempSubSpecie\n SubmitVal=$tempSubmitVal\n Position=${(pos.toJson()).toString()}\n ",
      );
    }
  }
}
