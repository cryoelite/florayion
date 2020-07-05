import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrDoer;

class ENCRV {
  final userName;
  int id=0;
  ENCRV(this.userName);
  String encrvDo() {
    findId();
    final userData = Firestore.instance.collection('userAU');
    final randEnc = encrDoer.SecureRandom(16).base64;
    userData
        .document(userName)
        .collection('keys')
        .document("${id+1}")
        .setData({"key": randEnc});
    print(randEnc);
    return randEnc;
  }
  void findId()async{
    final userData= Firestore.instance.collection('userAU');
    final QuerySnapshot idData=await userData.document(userName).collection('keys').getDocuments();
    this.id=idData.documents.length;
  }
}
