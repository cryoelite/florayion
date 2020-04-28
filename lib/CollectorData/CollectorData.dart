import 'package:cloud_firestore/cloud_firestore.dart';

class CollectorData {
  final specieData = Firestore.instance.collection('MainData');
  static final ff = ["Flora", "Fauna", "Disturbance"];
  static final subTypeFlora = ["Tree", "Shurb", "Grass"];
  static final subTypeFauna = ["Mammals", "Birds"];

  Future getFFSpecie(String subSpecie, int i) async {
    if (i == 0) {
      final ffdat = await specieData.document('FloraSpecies').get();
      final xSpecie = await ffdat[subSpecie];
      print("ayayaya $i $ffdat");
      return await xSpecie;
    } else {
      final ffdat = await specieData.document('FaunaSpecies').get();
      final xSpecie = await ffdat[subSpecie];
      print("ayayaya $i $xSpecie");
      return await xSpecie;
    }
  }
}
