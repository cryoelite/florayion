import 'package:cloud_firestore/cloud_firestore.dart';


class VersionAllowed {
  final String temp;
  VersionAllowed(this.temp);
  final version = Firestore.instance.collection('versionLive');
  Future<int> vChecker() async {
    final currentVersion = int.parse(temp);
    final QuerySnapshot checker = await version.getDocuments();
    if(currentVersion>=await checker.documents[0]["version"]){

      return 1;
    }
    else{

      return 0;
    }
  }
}
