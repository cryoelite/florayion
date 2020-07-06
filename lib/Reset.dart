import 'package:flutter/cupertino.dart';

import './LoginData/LocalUserData.dart';

class Reset {
  Reset(BuildContext context) {
    UserName.setLog(false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (_) => false,
    );
  }
}
