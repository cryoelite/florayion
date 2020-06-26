import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../CollectorData/localFFData.dart';

class CollectorData {
  final specieData = Firestore.instance.collection('MainData');
  static final ff = ["Flora", "Fauna", "Disturbance"];
  static final subTypeFlora = ["Tree", "Shurb", "Grass"];
  static final subTypeFauna = ["Mammals", "Birds"];
  static final subTypeDisturbance = ["Activity site", "Human", "NTFP collection", "Sand Mining", "livestock"];

  Future getFFSpecie(String subSpecie, String option) async {
    if (option == "flora") {
      List<String> fileya;
      final path = await LocalFF.localPath;
      final floraFile = File('$path/floraDat.txt');
      fileya = floraFile.readAsLinesSync();
      final temp=fileya[(fileya.indexWhere((elem) => elem==subSpecie))+1];
      final xSpecie=(temp.substring(1,temp.length-1)).split(", ");
      return xSpecie;
    } else if(option=="fauna") {
      List<String> fileya;
      final path = await LocalFF.localPath;
      final faunaFile = File('$path/faunaDat.txt');
      fileya = faunaFile.readAsLinesSync();
      final temp=fileya[(fileya.indexWhere((elem) => elem==subSpecie))+1];
      final xSpecie=(temp.substring(1,temp.length-1)).split(", ");
      return xSpecie;
    } else {
      List<String> fileya;
      final path = await LocalFF.localPath;
      final disFile = File('$path/disturbanceDat.txt');
      fileya = disFile.readAsLinesSync();
      final temp=fileya[(fileya.indexWhere((elem) => elem==subSpecie))+1];
      final xSpecie=(temp.substring(1,temp.length-1)).split(", ");
      return xSpecie;
    }
  }
}
