import 'package:cloud_firestore/cloud_firestore.dart';

class CreateText {
  int dataCountVal = 0;
  final userData = Firestore.instance.collection('userData');
  Future<int> getValue() async {
    final DocumentSnapshot dataCountDoc =
        await userData.document("DataCount").get();
    final dataCount = dataCountDoc.data;

    if (dataCountDoc.exists) {
      dataCountVal = int.parse(dataCount['docVal'].toString());
    }
    return dataCountVal;
  }
}
