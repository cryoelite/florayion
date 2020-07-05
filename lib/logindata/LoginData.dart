import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:florayion/LoginData/keySign.dart';
import 'LocalUserData.dart';

class LoginData {
  int i = 0;
  final String userName;
  final String userPass;
  var checker;
  var docs;
  LoginData(this.userName, this.userPass);
  final userData = Firestore.instance.collection('userAU');
  Future<int> checkData() async {
    checker = await userData.document(userName).get();
    QuerySnapshot pper = await userData.getDocuments();
    if (checker == null || !checker.exists) {
      return 0;
    } else {
      for (var i = 0; i < pper.documents.length; i++) {
        if (pper.documents[i][userName] != null) {
          if (pper.documents[i][userName] == userPass) {
            final encr = ENCRV(userName);
            UserName.setter(userName);
            UserName.writeIn(encr.encrvDo());
            return 1;
          } else {
            return 0;
          }
        }
      }
    }
    return 0;
  }
}
