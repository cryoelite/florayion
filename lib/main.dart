import 'package:flutter/material.dart';

import 'Routes/StartupLogo.dart';
import 'Routes/LoginRoute.dart';
import 'Routes/MainRoute.dart';
import './invalidVersion.dart';
import './Routes/LogChecker.dart';

void main() => runApp(MainRouteFunc());


class MainRouteFunc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartupLogo(),
        '/first': (context) => LoginRoute(),
        '/second': (context) => MainRoute(),
        '/third': (context) => InvalidVer(),
        '/fourth': (context) => LogChecker(),
      },
    );
  }
}
