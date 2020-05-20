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
      /* final info = localDat.readAsStringSync(); */

    } else {
      localDat.writeAsStringSync("id=${id.toString()}\n");
      localDat.writeAsStringSync("FF=$tempff\n");
      localDat.writeAsStringSync("SubSpecie=$tempSubSpecie\n");
      localDat.writeAsStringSync("SubmitVal=$tempSubmitVal\n");
      localDat.writeAsStringSync("Position=${pos.toString()}\n");
    }
  }
}
