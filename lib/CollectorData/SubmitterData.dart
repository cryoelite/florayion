import 'package:cloud_firestore/cloud_firestore.dart';

import '../LoginData/localData.dart';
import '../CreateText.dart';

class SubmitterData {
  int dataCountVal = 0;
  var id = 0;
  final tempff;
  final tempSubSpecie;
  final tempsubmitVal;
  final pos;
  SubmitterData(
      {this.tempff, this.tempSubSpecie, this.tempsubmitVal, this.pos}) {
    setter();
  }
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
    );
  }

  Future setter() async {
    final QuerySnapshot idFind = await userData
        .document(UserName.name)
        .collection("Data")
        .getDocuments();

    id = idFind.documents.length;
    print(id);
    this.tempff != "Disturbance"
        ? {
            userData
                .document(UserName.name)
                .collection("Data")
                .document(id.toString())
                .setData(
              {
                "FFType": this.tempff,
                "Sub-Specie": (this.tempSubSpecie),
                "SpecieName": (this.tempsubmitVal),
                "Location": ("$pos"),
              },
              merge: true,
            )
          }
        : userData
            .document(UserName.name)
            .collection("Data")
            .document(id.toString())
            .setData(
            {
              "FFType": this.tempff,
              "Disturbance": this.tempsubmitVal,
              "Location": ("$pos"),
            },
            merge: false,
          );
    dataCountUpdater();
  }
}
