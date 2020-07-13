import 'package:flutter/cupertino.dart';

import './LoginData/LocalUserData.dart';
import './LoginData/keySign.dart';

class Reset {
  Future resetApp(BuildContext context) async {
    await UserName.setLog(false);
    await UserName.deleter();
    final name = await UserName().getName();
    final randVal = await UserName().getRandVal();
    await ENCRV(await UserName().getName())
        .deleteKey(await UserName().getRandVal());
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (_) => false,
    );
  }
}
