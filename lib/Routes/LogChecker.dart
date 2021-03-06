import 'dart:async';
import 'package:flutter/material.dart';

import '../Utilities/Connectivity.dart';
import 'package:florayion/CollectorData/SetLocalCollection.dart';

class LogChecker extends StatefulWidget {
  @override
  _LogCheckerState createState() => _LogCheckerState();
}

class _LogCheckerState extends State<LogChecker> {
  void streamer(BuildContext context) {
    var lvcObject = Connectivity();
    StreamSubscription<bool> stream;
    lvcObject.startTimer();
    Stream lvcStream = lvcObject.strClr;
    stream = lvcStream.listen((event) {
      print("$event");
      if (event == true) {
        SetLocalCollection.init();
        stream.cancel();
        lvcObject.disabler();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/first',
          (_) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    streamer(context);
    return buildContainer();
  }

  Container buildContainer() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Card(
          elevation: 8,
          child: Center(
            child: Text(
                "You are offline and not logged in. Please check connectivity."),
          ),
        ),
      ),
    );
  }
}
