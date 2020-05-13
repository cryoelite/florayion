import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:florayion/LoginData/keySign.dart';
import '../LoginData/localData.dart';

class RegisterData {
  final String userName;
  final String userPp;
  RegisterData(this.userName, this.userPp);
  final userData = Firestore.instance.collection('userAU');
  Future registerData() async {
    var checker = await userData.document(userName).get();
    if (checker == null || !checker.exists) {
      await userData.document(userName).setData({
        userName: userPp,
      });
      final encr = ENCRV(userName);
      UserName.setter(userName);
      UserName.writeIn(encr.encrvDo());
      return 1;
    } else {
      return 0;
    }
  }
}
