import 'dart:async';
import 'package:flutter/material.dart';
import '../liveChecker.dart';

class LogChecker extends StatefulWidget {
  @override
  _LogCheckerState createState() => _LogCheckerState();
}

class _LogCheckerState extends State<LogChecker> {
  void streamer(BuildContext context) {
    var lvcObject = LVC();
    StreamSubscription<bool> stream;
    lvcObject.startTimer();
    Stream lvcStream = lvcObject.strClr;
    stream = lvcStream.listen((event) {
      print("$event");
      if (event == true) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/first',
          (_) => false,
        );
        streamCloser(stream);
        disabler(lvcObject);
      }
    });
  }

  void streamCloser(StreamSubscription<bool> stream) {
    stream.cancel();
  }

  void disabler(LVC obj) {
    obj.disabler();
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
            child: Text("Please Login before using the app in offline mode."),
          ),
        ),
      ),
    );
  }
}
