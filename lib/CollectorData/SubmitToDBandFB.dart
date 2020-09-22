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
  int transect;
  SubmitToDBandFB(
      {this.tempff,
      this.tempSubSpecie,
      this.tempSubmitVal,
      this.filedb,
      this.transect});

  Future<void> submitToDb() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final String posVal =
        "${pos.latitude}+${pos.longitude}+${pos.altitude}+${pos.accuracy}";
    int id = await filedb.insertTask(
      TasksCompanion(
        ff: Value(this.tempff),
        pos: Value(posVal),
        subSpecie: Value(this.tempSubSpecie),
        submitVal: Value(this.tempSubmitVal),
        transect: Value(this.transect),
      ),
    );
    print("Succes: $id");
  }

  Future<int> randValChecker() async {
    final userData = Firestore.instance.collection('userAU');
    final name = await UserDetails().getName();

    final String randVal = await UserDetails().getRandVal();
    final QuerySnapshot getter =
        await userData.document(name).collection('keys').getDocuments();

    print("Herein randchecker and key length: ${getter.documents.length}");
    for (int i = 0; i < getter.documents.length; ++i) {
      int flag = 0;
      final temp = getter.documents[i];
      temp.data.forEach(
        (key, value) {
          if (value == randVal) {
            print("RandVal Match.");
            flag = 1;
          }
        },
      );
      if (flag == 1) {
        return 1;
      }
    }

    print("randVal : $randVal");
    print("RandVal Mismatch, Re-login .");
    return 0;
  }

  Future<void> syncDBtoFireBase(FDB filedb) async {
    final List getDat = await filedb.getId();
    for (int i = 0; i < getDat.length; ++i) {
      if (await DataConnectionChecker().hasConnection == true &&
          await randValChecker() == 1) {
        final tempDat = await filedb.getSinglyTask(getDat[i]);
        final SubmitterData submit = SubmitterData(
          pos: tempDat.pos,
          tempSubSpecie: tempDat.subSpecie,
          tempff: tempDat.ff,
          tempsubmitVal: tempDat.submitVal,
          transect: tempDat.transect,
        );
        await submit.setter();
        await filedb.deleteSinglyTask(getDat[i]);
        print("Submission Success");
      }
    }
  }
}
