import 'package:florayion/CollectorData/SubmitterData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';
import 'package:moor_flutter/moor_flutter.dart';
import 'moordb.dart';
import '../LoginData/localData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  }

  Future<int> validator() async {
    final userData = Firestore.instance.collection('userAU');
    final name = UserName.name;
    final randVal = "(${UserName.randVal})";
    final getter =
        await userData.document(name).collection('keys').getDocuments();
    for (int i = 0; i < getter.documents.length; ++i) {
      final temp = getter.documents.elementAt(i);
      final tempString = temp.data.values.toString();
      if (randVal == tempString) {
        return 1;
      }
    }
    return 0;
  }

  Future<void> syncX(FDB filedb) async {
    final List getDat = await filedb.getId();
    for (int i = 1; i < getDat.length; ++i) {
      if (await DataConnectionChecker().hasConnection == true &&
          await validator() == 1) {
        final tempDat = await filedb.getSinglyTask(getDat[i]);
        SubmitterData(
            pos: tempDat.pos,
            tempSubSpecie: tempDat.subSpecie,
            tempff: tempDat.ff,
            tempsubmitVal: tempDat.submitVal);
        filedb.deleteSinglyTask(getDat[i]);
        print("Submission Success");
      }
    }
  }
}
