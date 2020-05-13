import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrDoer;

class ENCRV {
  final userName;
  ENCRV(this.userName);
  String encrvDo() {
    final userData = Firestore.instance.collection('userAU');
    final randEnc = encrDoer.SecureRandom(8).base64;
    userData
        .document(userName)
        .collection('keys')
        .document(randEnc)
        .setData({"0": randEnc});
    print(randEnc);
    return randEnc;
  }
}
