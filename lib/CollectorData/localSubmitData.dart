/* import 'dart:io';

import 'dart:convert';
import 'package:florayion/CollectorData/SubmitterData.dart';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:sqflite/sqflite.dart'; */
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import '../LoginData/localData.dart';

class LocalSubmission {
  int id = 0;
  List<int> submitted;
  String tempff;
  static Database db4x;
  String tempSubSpecie;
  String tempSubmitVal;
  var db4xPath;
  var path;
  LocalSubmission({this.tempff, this.tempSubSpecie, this.tempSubmitVal}) {
    setDb();
  }

  Future<void> setDb() async {
    final dbName = "StorageHolder";
    db4xPath = await getDatabasesPath();
    path = join(db4xPath, dbName);
  }

  Future<void> submission() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final tSql = '''CREATE TABLE StorageF
    (

      $id INTEGER PRIMARY KEY
      $tempff TEXT,
      $tempSubSpecie TEXT,
      $tempSubmitVal TEXT,
      ${(pos.toJson()).toString()} TEXT
    ) ''';
    await db4x.execute(tSql);
    if (await Directory(dirname(path)).exists()) {
      print("ya");
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
  }
}
/* final path = await UserName.localPath;
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

  Future<void> sender(String element) async {
    final tempid = int.tryParse(
        element.substring(element.indexOf("id=") + 3, element.indexOf("-.-")));

    tempff = element.substring(
        element.indexOf("FF=") + 3, element.indexOf("--SubSpecie"));
    tempSubSpecie = element.substring(
        element.indexOf("SubSpecie=") + 10, element.indexOf("--SubmitVal"));
    tempSubmitVal = element.substring(
        element.indexOf("SubmitVal=") + 10, element.indexOf("--Position"));
    final pos = element.substring(element.indexOf("Position=") + 9);
    if (await DataConnectionChecker().hasConnection == true) {
      final submit = SubmitterData(
          tempff: tempff,
          tempSubSpecie: tempSubSpecie,
          tempsubmitVal: tempSubmitVal,
          pos: pos);
      submit.setter();
      submitted.add(tempid);
    }
  }

  Future<int> sendSubmission() async {
    final path = await UserName.localPath;
    File localDat = File('$path/submission.txt');
    print("hai");
    if (localDat.existsSync()) {
      print("here");
      await localDat
          .openRead()
          .map(utf8.decode)
          .transform(LineSplitter())
          .forEach((element) {
        sender(element);
      });
      yeetUsDeleteUs(localDat);
    } else {
      return 1;
    }
    return 0;
  }

  Future<void> yeetUsDeleteUs(File localDat) async {
    RandomAccessFile raf = await localDat.open(mode: FileMode.writeOnlyAppend);

  }
} */
