import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import '../LoginData/tempData.dart';

class CollectorData {
  String tempff = "";
  String tempSpecie = "";

  collectorDataInit(String tempA, String tempB) {
    tempff = tempA;
    tempSpecie = tempB;
  }

  final specieData = Firestore.instance.collection('MainData');
  static final ff = ["Flora", "Fauna", "Disturbance"];
  static final subTypeFlora = ["Tree", "Shurb", "Herb"];
  static final subTypeFauna = ["Mammals", "Birds"];
  final userData = Firestore.instance.collection('userData');
  Future getFFSpecie(String subSpecie, int i) async {
    if (i == 0) {
      final ffdat = await specieData.document('FaunaSpecies').get();
      final xSpecie = await ffdat[subSpecie];
      print("ayayaya $ffdat");
      return await xSpecie;
    } else {
      final ffdat = await specieData.document('FloraSpecies').get();
      final xSpecie = await ffdat[subSpecie];
      print("ayayaya $xSpecie");
      return await xSpecie;
    }
  }

  Future setter() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userData
        .document(UserName.name)
        .collection(UserName.name)
        .document(UserName.name)
        .setData(
      {
        UserName.name:
            ("${pos.latitude.toString()} + ${pos.longitude.toString()}"),
      },
      merge: true,
    );
  }
}
