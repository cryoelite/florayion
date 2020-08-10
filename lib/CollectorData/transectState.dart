import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../LoginData/LocalUserData.dart';

class TransectState {
  bool transectState;
  int currentTransect;

  Future<File> get localFile async {
    final dir = await getTemporaryDirectory();
    final path = dir.path;
    final transectFile = File('$path/transectFile.txt');
    return transectFile;
  }

  Future<Map<bool, int>> get getTransectState async {
    final transectFile = await localFile;
    if (transectFile.existsSync()) {
      String fileData = await transectFile.readAsString();
      bool state = fileData
              .substring(fileData.indexOf("=") + 1, fileData.indexOf("\n"))
              .toLowerCase() ==
          'true';
      currentTransect =
          int.parse(fileData.substring(fileData.lastIndexOf("=") + 1));
      Map<bool, int> value = {state: currentTransect};
      return value;
    } else {
      Map<bool, int> value = {false: 1};
      return value;
    }
  }

  Future<int> get transectNumber async {
    final QuerySnapshot userData = await Firestore.instance
        .collection("userData")
        .document(await UserName().getName())
        .collection("Data")
        .getDocuments();

    int maxTransect = 0;
    userData.documents.forEach(
      (element) {
        if (maxTransect > element.data["Transect"]) {
          maxTransect = element.data["Transect"];
        }
      },
    );
    return maxTransect;
  }

  Future<void> setTransectState(Map<bool, int> map) async {
    final transectFile = await localFile;
    await transectFile.writeAsString(
        "TransectState=${map.keys.first.toString()}\nTransectValue=${map.values.first.toString()}",
        mode: FileMode.writeOnly);

    return;
  }
}
