import 'package:flutter/cupertino.dart';

import '../LoginData/LocalUserData.dart';
import '../LoginData/keySign.dart';

class Reset {
  Future resetApp(BuildContext context) async {
    final name = await UserDetails().getName();
    final randVal = await UserDetails().getRandVal();
    print("name $name and key $randVal");
    final encTemp = ENCRV(name);
    await encTemp.deleteKey(randVal);
    await UserDetails.setLog(false);
    await UserDetails.deleter();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (_) => false,
    );
  }
}
