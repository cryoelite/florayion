import 'package:cloud_firestore/cloud_firestore.dart';

class LoginData {
  final String userName;
  final String userPp;
  var checker;
  var pper;
  LoginData(this.userName, this.userPp);
  final userData = Firestore.instance.collection('userAU');
  Future<int> checkData() async {
    checker = await userData.document(userName).get();
    if (checker == null || !checker.exists) {
      return 0;
    } else {
      print(await checker);
      return 1;
      /* pper = await checker
      if (pper != null && pper.exists) {
        return 1;
      } else {
        return 0;
      } */
    }
  }
}
