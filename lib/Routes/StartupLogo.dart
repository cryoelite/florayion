import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

import 'package:florayion/versioner.dart';
import '../LoginData/localData.dart';
import 'package:florayion/CollectorData/localFFData.dart';
import '../routeConfig.dart';

class StartupLogo extends StatelessWidget {
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
    RouterConf().init(context);
    LocalFF.init();
    Future<void>.delayed(
      Duration(seconds: 5),
      () async {
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
}
