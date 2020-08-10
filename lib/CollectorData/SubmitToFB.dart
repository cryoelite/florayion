import 'package:cloud_firestore/cloud_firestore.dart';

import '../LoginData/LocalUserData.dart';

class SubmitterData {
  int dataCountVal = 0;
  var id = 0;
  final tempff;
  final tempSubSpecie;
  final tempsubmitVal;
  final pos;
  final int transect;

  SubmitterData(
      {this.tempff,
      this.tempSubSpecie,
      this.tempsubmitVal,
      this.pos,
      this.transect});
  final userData = Firestore.instance.collection('userData');

  Future<void> dataCountUpdater() async {
    final DocumentSnapshot dataCountDoc =
        await userData.document("DataCount").get();
    final dataCount = dataCountDoc.data;

    if (dataCountDoc.exists) {
      dataCountVal = int.parse(dataCount['docVal'].toString());
    }
    userData.document("DataCount").setData(
      {
        "docVal": dataCountVal + 1,
      },
      merge: true,
    );
  }

  Future setter() async {
    final QuerySnapshot idFind = await userData
        .document(await UserName().getName())
        .collection("Data")
        .getDocuments();
    final QuerySnapshot transectFind = await userData
        .document(await UserName().getName())
        .collection("Data")
        .getDocuments();
    int maxTransect = 0;
    transectFind.documents.forEach(
      (element) {
        if (maxTransect > element.data["Transect"]) {
          maxTransect = element.data["Transect"];
        }
      },
    );
    id = idFind.documents.length;
    print(id);
    print(await UserName().getName());
    print(
        "Max Transect ${maxTransect.toString()} and internal transect ${this.transect.toString()}");
    await userData
        .document(await UserName().getName())
        .collection("Data")
        .document(id.toString())
        .setData(
      {
        "FFType": this.tempff,
        "Sub-Specie": (this.tempSubSpecie),
        "SpecieName": (this.tempsubmitVal),
        "Location": ("$pos"),
        "Time": DateTime.now(),
        "Transect": maxTransect + transect,
      },
      merge: true,
    );
    await totalEntries();
  }

  Future totalEntries() async {
    await userData.document(await UserName().getName()).setData(
      {
        "TotalEntries": ((id + 1).toString()),
      },
      merge: true,
    );
    await dataCountUpdater();
  }
}
