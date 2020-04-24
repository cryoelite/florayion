import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../LoginData/tempData.dart';

class CollectorData {
  final String tempff;
  final String tempSpecie;

  CollectorData(this.tempff, this.tempSpecie);
  static final specie = ["Cow", "BhauBhau"];
  static final ff = ["Flora", "Fauna","Disturbance"];
  final userData = Firestore.instance.collection('userData');
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
