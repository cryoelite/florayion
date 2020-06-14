import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';

import '../LoginData/localData.dart';

class LocalSubmission {
  int id = 0;
  final String tempff;
  final String tempSubSpecie;
  final String tempSubmitVal;
  LocalSubmission({this.tempff, this.tempSubSpecie, this.tempSubmitVal});


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
          info.lastIndexOf(
            "-.-",
          ),
        ),
      );
      print("Current ID: $currentId");
      localDat.writeAsStringSync(
        "id=${(currentId + 1).toString()}-.-FF=$tempff--SubSpecie=$tempSubSpecie--SubmitVal=$tempSubmitVal--Position=${(pos.toJson()).toString()}\n",
        mode: FileMode.append,
      );

    } else {
      print("doing");
      localDat.writeAsStringSync(
        "id=0-.-FF=$tempff--SubSpecie=$tempSubSpecie--SubmitVal=$tempSubmitVal--Position=${(pos.toJson()).toString()}\n",
        mode: FileMode.write,
      );
    }
  }

  Future<int> sendSubmission() async {
    id = 0;
    final path = await UserName.localPath;
    File localDat = File('$path/submission.txt');
    print("hai");
    if (localDat.existsSync()) {
      print("here");
      localDat
          .openRead()
          .map(utf8.decode)
          .transform(LineSplitter())
          .forEach((element) {
        print(element);
      });
    } else {
      return 1;
    }
    return 0;
  }
}
