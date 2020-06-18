import 'package:geolocator/geolocator.dart';

import 'dart:async';
import 'package:moor_flutter/moor_flutter.dart';
import 'moordb.dart';
//import '../LoginData/localData.dart';

class LocalSubmission {
  List<int> submitted;
  String tempff;
  String tempSubSpecie;
  String tempSubmitVal;
  FDB filedb;
  LocalSubmission(
      {this.tempff, this.tempSubSpecie, this.tempSubmitVal, this.filedb}) {
    /* getId(); */
  }
  Future<void> getId() async {
    final temp = await filedb.getId();
    print(temp.toString());
  }

  Future<void> submission() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    int id=await filedb.insertTask(
      TasksCompanion(
        ff: Value(this.tempff),
        pos: Value((pos.toJson()).toString()),
        subSpecie: Value(this.tempSubSpecie),
        submitVal: Value(this.tempSubmitVal),
      ),
    );
    print("Succes: $id");
  }
}
