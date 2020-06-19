import 'package:geolocator/geolocator.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
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
      {this.tempff, this.tempSubSpecie, this.tempSubmitVal, this.filedb});

  Future<void> submission() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    int id = await filedb.insertTask(
      TasksCompanion(
        ff: Value(this.tempff),
        pos: Value((pos.toJson()).toString()),
        subSpecie: Value(this.tempSubSpecie),
        submitVal: Value(this.tempSubmitVal),
      ),
    );
    print("Succes: $id");
    syncX();
  }

  Future<int> syncX() async {
    final int getDat = await filedb.getId();
    final tempDat = await filedb.getSinglyTask(getDat);
    print(await filedb.getId());
    /* await filedb.deleteSinglyTask(getDat);
    print(await filedb.getId()); */
    /* for (int i = 0; i < getDat; ++i) {
      if (await DataConnectionChecker().hasConnection == true) {
        
      }
    } */
  }
}
