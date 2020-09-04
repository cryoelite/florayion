import 'package:flutter/cupertino.dart';

import '../LoginData/LocalUserData.dart';
import '../LoginData/keySign.dart';

class Reset {
  Future resetApp(BuildContext context) async {
    final name = await UserName().getName();
    final randVal = await UserName().getRandVal();
    print("name $name and key $randVal");
    final encTemp = ENCRV(name);
    await encTemp.deleteKey(randVal);
    await UserName.setLog(false);
    await UserName.deleter();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (_) => false,
    );
  }
}
