import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:florayion/versioner.dart';

import '../LoginData/localData.dart';
import 'package:florayion/CollectorData/localFFData.dart';
import '../routeConfig.dart';
import '../liveChecker.dart';

class StartupLogo extends StatefulWidget {
  @override
  _StartupLogoState createState() => _StartupLogoState();
}

class _StartupLogoState extends State<StartupLogo> {
  final lvcobject = LVC();
  void streamFunc(BuildContext context) async {
    if (await DataConnectionChecker().hasConnection == true) {
      StreamSubscription<bool> stream;
      lvcobject.startTimer();
      proceeder(context);
      Stream lvcStream = lvcobject.strClr;
      stream = lvcStream.listen((event) {
        print("$event");
        if (event == false) {
          stream.cancel();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/second',
            (_) => false,
          );
        }
      });
      if (await lvcStream.isEmpty == false) {
        stream.cancel();
        lvcobject.disabler();
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/second',
        (_) => false,
      );
    }
  }

  checkVersion() async {
    final currentVersion = await GetVersion.projectCode;
    final checker = VersionAllowed(currentVersion);

    if (await checker.vChecker() == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    streamFunc(context);
    RouterConf().init(context);
    LocalFF.init();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.orange,
      child: buildContainer(),
    );
  }

  Container buildContainer() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Image.asset(
          'lib/ImageAsset/xx.png',
        ),
      ),
    );
  }

  void proceeder(BuildContext context) {
    Future<void>.delayed(
      Duration(seconds: 5),
      () async {
        lvcobject.disabler();
        if (await checkVersion() == 1) {
          final checker = await UserName.checker();
          if (checker == 1) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/second',
              (_) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/first',
              (_) => false,
            );
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/third',
            (_) => false,
          );
        }
      },
    );
  }
}
