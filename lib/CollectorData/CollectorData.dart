import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../CollectorData/localFFData.dart';

class CollectorData {
  final specieData = Firestore.instance.collection('MainData');
  static final ff = ["Flora", "Fauna", "Disturbance"];
  static final subTypeFlora = ["Tree", "Shurb", "Grass"];
  static final subTypeFauna = ["Mammals", "Birds"];

  Future getFFSpecie(String subSpecie, int i) async {
    if (i == 0) {
      List<String> fileya;
      final path = await LocalFF.localPath;
      final floraFile = File('$path/floraDat.txt');
      fileya = floraFile.readAsLinesSync();
      final temp=fileya[(fileya.indexWhere((elem) => elem==subSpecie))+1];
      final xSpecie=(temp.substring(1,temp.length-1)).split(", ");
      return xSpecie;
    } else {
      List<String> fileya;
      final path = await LocalFF.localPath;
      final faunaFile = File('$path/faunaDat.txt');
      fileya = faunaFile.readAsLinesSync();
      final temp=fileya[(fileya.indexWhere((elem) => elem==subSpecie))+1];
      final xSpecie=(temp.substring(1,temp.length-1)).split(", ");
      return xSpecie;
    }
  }
}
