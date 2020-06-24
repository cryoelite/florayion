import 'dart:async';

import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import '../routeConfig.dart';
import '../CreateText.dart';

class MBX extends StatefulWidget {
  final Stream<DataConnectionStatus> slr;
  final StreamController<int> str = StreamController();
  Timer timer;
  Stream streamAlpha;

  void getVal() {
    timer = Timer.periodic(Duration(seconds: 5), (_) async {
      str.sink.add(
        await CreateText().getValue(),
      );
    });
  }

  void canceller() {
    str.close();
    timer.cancel();
  }

  MBX({Key key})
      : slr = DataConnectionChecker().onStatusChange,
        super(key: key) {
    streamAlpha = str.stream;
    getVal();
  }
  @override
  _MBXState createState() => _MBXState();
}

class _MBXState extends State<MBX> {
  final double _elevate = 5;
  final double _defHeight = (RouterConf.blockV) * 10;
  final double _defWidth = (RouterConf.blockH) * 80;
  final EdgeInsets _defPad = EdgeInsets.only(
      left: RouterConf.blockH * 4, right: RouterConf.blockH * 4);
  final EdgeInsets _defPad2 = EdgeInsets.only(
      top: RouterConf.blockV * 0.5, bottom: RouterConf.blockV * 2);
  final _defColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF19191a),
          title: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => RadialGradient(
                center: Alignment.topLeft,
                radius: 1.0,
                colors: [
                  Colors.yellow,
                  Colors.deepOrange,
                ],
                tileMode: TileMode.mirror,
              ).createShader(bounds),
              child: Text(
                "Dashboard",
                style: TextStyle(fontSize: (RouterConf.blockV) * 4),
              ),
            ),
          ),
        ),
        body: Container(
          height: RouterConf.vArea,
          width: RouterConf.hArea,
          color: Colors.white,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: StreamBuilder(
                  stream: widget.slr,
                  initialData: true,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("s");
                    } else {
                      if (snapshot.data == DataConnectionStatus.disconnected) {
                        return Padding(
                          padding: _defPad2,
                          child: Card(
                            elevation: _elevate,
                            child: Container(
                              height: RouterConf.blockV * 5,
                              width: _defWidth,
                              color: _defColor,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      " Please Check Connectivity !",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          elevation: _elevate,
                          child: Container(
                            height: 0,
                            width: 0,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding: _defPad2,
                child: Card(
                  elevation: _elevate,
                  child: Container(
                    color: _defColor,
                    height: _defHeight,
                    width: _defWidth,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: _defPad,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: RouterConf.blockH * 10,
                              width: RouterConf.blockV * 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: RouterConf.blockH * 0.6,
                                  ),
                                ),
                                child: Center(
                                  child: StreamBuilder<int>(
                                    stream: widget.streamAlpha,
                                    builder: (context, snapshot) {
                                      return FittedBox(
                                        child: Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                              fontSize: RouterConf.blockH * 6),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: _defPad,
                          child: Text(": Total number of submissions."),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: _defPad2,
                child: Card(
                  elevation: _elevate,
                  child: Container(
                    width: _defWidth,
                    height: _defHeight,
                    color: _defColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
