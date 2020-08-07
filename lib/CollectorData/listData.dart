import 'package:cloud_firestore/cloud_firestore.dart';

import '../LoginData/LocalUserData.dart';

class ListData {
  Future<List> getList() async {
    final QuerySnapshot submissions = await Firestore.instance
        .collection('userData')
        .document(await UserName().getName())
        .collection('Data')
        .getDocuments();
    final List<DocumentSnapshot> documents = submissions.documents;
    List<Map<String, dynamic>> valX = [];
    for (int i = 0; i < submissions.documents.length; ++i) {
      final temp = documents[i].data;
      valX.add(temp);
    }
    return valX;
  }
}
