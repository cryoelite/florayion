import 'package:florayion/CollectorData/SubmitToFB.dart';
import 'package:geolocator/geolocator.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';
import 'package:moor_flutter/moor_flutter.dart';
import 'moordb.dart';
import '../LoginData/LocalUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitToDBandFB {
  List<int> submitted;
  String tempff;
  String tempSubSpecie;
  String tempSubmitVal;
  FDB filedb;
  SubmitToDBandFB(
      {this.tempff, this.tempSubSpecie, this.tempSubmitVal, this.filedb});

  Future<void> submitToDb() async {
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

  Future<int> randValChecker() async {
    final userData = Firestore.instance.collection('userAU');
    final name = UserName.name;

    final randVal = "(${UserName.randVal})";
    final QuerySnapshot getter =
        await userData.document(name).collection('keys').getDocuments();
    
    print("Herein randchecker");
    for (int i = 0; i < getter.documents.length ; ++i) {
      final temp = getter.documents[i];
      final tempString = temp.data.values.toString();
      print("tempstring : $tempString");
      if (randVal == tempString) {
        print("RandVal Match.");
        return 1;
      }
    }
    print(randVal);
    print("RandVal Mismatch, Re-login .");
    return 0;
  }

  Future<void> syncDBtoFireBase(FDB filedb) async {
    final List getDat = await filedb.getId();
    for (int i = 1; i < getDat.length; ++i) {
      if (await DataConnectionChecker().hasConnection == true &&
          await randValChecker() == 1) {
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
