import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:florayion/Utilities/VersionChecker.dart';
import '../LoginData/LocalUserData.dart';
import 'package:florayion/CollectorData/SetLocalCollection.dart';
import '../Utilities/routeConfig.dart';
import '../Utilities/Connectivity.dart';

class StartupLogo extends StatefulWidget {
  @override
  _StartupLogoState createState() => _StartupLogoState();
}

class _StartupLogoState extends State<StartupLogo> {
  var localDataChecker;
  var lvcObject = Connectivity();
  void streamFunc(BuildContext context) async {
    localDataChecker = await UserName.checker();
    if (await DataConnectionChecker().hasConnection == true) {
      SetLocalCollection.init();
      proceeder(context);   
      streamer();
    } else {
      loginChecker();
    }
  }

  void streamer() {
    StreamSubscription<bool> stream;
    lvcObject.startTimer();
    Stream lvcStream = lvcObject.strClr;
    stream = lvcStream.listen((event) {
      print("$event");
      if (event == false) {
        loginChecker();
        stream.cancel();
        lvcObject.disabler();
      }
    });
  }

  void loginChecker() {
    if (localDataChecker == 1) {
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
  }

  checkVersion() async {
    final currentVersion = await GetVersion.projectCode;
    final checker = VersionChecker(currentVersion);

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
          'lib/ImageAsset/splashScreen.png',
        ),
      ),
    );
  }

  void proceeder(BuildContext context) {
    Future<void>.delayed(
      Duration(seconds: 3),
      () async {
        lvcObject.disabler();
        if (await checkVersion() == 1) {
          if (localDataChecker == 1) {
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
