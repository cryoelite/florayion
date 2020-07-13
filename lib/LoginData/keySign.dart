import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrDoer;

class ENCRV {
  final userName;
  int id = 0;
  ENCRV(this.userName);
  Future<String> encrvDo() async {
    await findId();
    final userData = Firestore.instance.collection('userAU');
    final randEnc = encrDoer.SecureRandom(16).base64;
    userData
        .document(userName)
        .collection('keys')
        .document("${id + 1}")
        .setData({"key": randEnc});
    print(randEnc);
    return randEnc;
  }

  Future findId() async {
    final userData = Firestore.instance.collection('userAU');
    final QuerySnapshot idData =
        await userData.document(userName).collection('keys').getDocuments();
    this.id = idData.documents.length;
  }

  Future deleteKey(String randVal) async {
    final userData = Firestore.instance
        .collection('userAU')
        .document(userName)
        .collection('keys');
    final QuerySnapshot keyIds = await userData.getDocuments();

    for (int i = 0; i < keyIds.documents.length; ++i) {
      final temp = keyIds.documents[i];
      var flag = 0;
      temp.data.forEach(
        (key, value) {
          if (value == randVal) {
            print("RandVal Match.");
            flag = 1;
          }
        },
      );
      if (flag == 1) {
        await userData.document('${i + 1}').delete();
        print("KeyDelete complete.");
        return;
      }
    }
    print("KeyDelete Incomplete.");
  }
}
