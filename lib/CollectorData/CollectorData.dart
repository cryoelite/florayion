
import 'dart:io';

import '../CollectorData/localFFData.dart';

class CollectorData {
  final ff = ["Flora", "Fauna", "Disturbance"];
  final subTypeFlora = ["Tree", "Shurb", "Grass"];
  final subTypeFauna = ["Mammals", "Birds"];
  final subTypeDisturbance = [
    "Activity site",
    "Human",
    "NTFP collection",
    "Sand Mining",
    "livestock"
  ];
  List<String> fileyaDis;
  List<String> fileyaFlora;
  List<String> fileyaFauna;

  CollectorData() {
    init();
  }

  Future init() async {
    final path = await LocalFF.localPath;
    final faunaFile = File('$path/faunaDat.txt');
    fileyaFauna = await faunaFile.readAsLines();

    final floraFile = File('$path/floraDat.txt');
    fileyaFlora = await floraFile.readAsLines();

    final disFile = File('$path/disturbanceDat.txt');
    fileyaDis = await disFile.readAsLines();
  }

  Future getFFSpecie(String subSpecie, String option) async {
    if (option == "Flora") {
      final temp = fileyaFlora[
          (fileyaFlora.indexWhere((elem) => elem == subSpecie)) + 1];
      final xSpecie = (temp.substring(1, temp.length - 1)).split(", ");
      return xSpecie;
    } else if (option == "Fauna") {
      final temp = fileyaFauna[
          (fileyaFauna.indexWhere((elem) => elem == subSpecie)) + 1];
      final xSpecie = (temp.substring(1, temp.length - 1)).split(", ");
      return xSpecie;
    } else {
      final temp =
          fileyaDis[(fileyaDis.indexWhere((elem) => elem == subSpecie)) + 1];
      final xSpecie = (temp.substring(1, temp.length - 1)).split(", ");
      return xSpecie;
    }
  }
}
