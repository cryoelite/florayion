import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Routes/StartupLogo.dart';
import 'Routes/LoginRoute.dart';
import 'Routes/MainRoute.dart';
import './invalidVersion.dart';
import './Routes/LogChecker.dart';

void main() => runApp(MainRouteFunc());

class MainRouteFunc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
      ),
    );
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartupLogo(),
        '/first': (context) => LoginRoute(),
        '/second': (context) => MBX(),
        '/third': (context) => InvalidVer(),
        '/fourth': (context) => LogChecker(),
      },
    );
  }
}
