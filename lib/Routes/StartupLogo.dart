import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class StartupLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(
      Duration(seconds: 5),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/first',
          (_) => false,
        );
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
      child: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'lib/ImageAsset/xx.png',
            ),
          ],
        ),
      ),
    );
  }
}
