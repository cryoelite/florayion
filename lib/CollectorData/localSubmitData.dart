import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'dart:async';


//import '../LoginData/localData.dart';

class LocalSubmission {
  int idx = -1;
  List<int> submitted;
  final nameTable = "StorageGTF";
  String tempff;
  String tempSubSpecie;
  String tempSubmitVal;
  LocalSubmission({this.tempff, this.tempSubSpecie, this.tempSubmitVal});

  /* Future<String> setDb() async {
    final dbName = "StorageHolder.db";
    final db4xPath = await getDatabasesPath();
    final path = join(db4xPath, dbName);
    if (await Directory(dirname(path)).exists()) {
      print("ya");
      setId(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
      idx = 0;
      print("na does not");
    }
    return path;
  }

  Future<void> setId(String path) async {
    Database db = await openReadOnlyDatabase(path);
    final sql = "SELECT MAX(id) FROM $nameTable";
    final temp = await db.rawQuery(sql);
    print("int: ${temp.toString()}");
    idx = int.tryParse(temp[0]["MAX(id)"]);
    print("int: $idx");
    db.close();
  }

  void setter() {
    this.idx += 1;
  }

  Future<void> createDb(Database db) async {
    final tSql = '''CREATE TABLE $nameTable
    (
      id INTEGER PRIMARY KEY,
      FF TEXT,
      SubSpecie TEXT,
      SubmitVal TEXT,
      pos TEXT
    )''';
    await db.execute(tSql);
    print("Here we are");
  }

  Future<void> onCreate(Database db, int version) async {
    await createDb(db);
  }

  Future<void> dbSubmit(Database db) async {
    int id = this.idx;
    print("ID HERE::: $id");
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Map<String, dynamic> values = {
      "id": id,
      "FF": tempff,
      "SubSpecie": tempSubSpecie,
      "SubmitVal": tempSubmitVal,
      "pos": (pos.toJson()).toString()
    };
    await db.insert(nameTable, values);
  }

  Future<void> submission() async {
    final path = await setDb();
    Database db4x = await openDatabase(path, version: 1, onCreate: onCreate);
    await dbSubmit(db4x);
    db4x.close();
  }

  Future<void> checkSubmission() async {
    final path = await setDb();
    Database db4x = await openReadOnlyDatabase(path);
    dynamic records = await db4x.query(nameTable);
    print(">>>>> $records");
    db4x.close();
  } */
}

