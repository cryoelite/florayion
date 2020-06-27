import 'dart:async';

import 'package:florayion/CollectorData/CollectorData.dart';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import '../routeConfig.dart';
import '../CreateText.dart';

class MBX extends StatefulWidget {
  @override
  _MBXState createState() => _MBXState();
}

class _MBXState extends State<MBX> {
  var i = 0;
  final Stream<DataConnectionStatus> slr;
  final StreamController<int> str = StreamController();
  Timer timer;
  Stream streamAlpha;

  _MBXState() : slr = DataConnectionChecker().onStatusChange {
    streamAlpha = str.stream;
    getVal();
    mapper();
  }

  final _formKey = GlobalKey<FormState>();
  final double _elevate = 5;
  final double _defHeight = (RouterConf.blockV) * 10;
  final double _defWidth = (RouterConf.blockH) * 80;
  final EdgeInsets _defPad = EdgeInsets.only(
      left: RouterConf.blockH * 4, right: RouterConf.blockH * 4);
  final EdgeInsets _defPad2 = EdgeInsets.only(
      top: RouterConf.blockV * 0.5, bottom: RouterConf.blockV * 2);
  final _defColor = Colors.grey[200];
  final double _boxWidth = (RouterConf.blockH) * 20;
  final double _boxHeight = (RouterConf.blockV) * 8;

  void canceller() {
    str.close();
    timer.cancel();
  }

  void getVal() {
    timer = Timer.periodic(Duration(seconds: 5), (_) async {
      str.sink.add(
        await CreateText().getValue(),
      );
    });
  }

  void dispose() {
    canceller();
    super.dispose();
    print("MainRoute disposed successfully.");
  }

  //Variables that hold collection field info
  var selectedFF;
  var selectedSubType;
  List<DropdownMenuItem<String>> ff;
  var subFlora;
  var subFauna;
  var subType;
  var subDisturbance;
  var subTypeInfo;

  subMapper(var val) {
    var temp = DropdownMenuItem<String>(
        child: Text(
          val,
          style: TextStyle(fontSize: (RouterConf.blockV) * 1.9),
        ),
        value: val);

    return temp;
  }

  void mapper() {
    ff = CollectorData.ff.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
    subFlora = CollectorData.subTypeFlora.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
    subFauna = CollectorData.subTypeFauna.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
    subDisturbance =
        CollectorData.subTypeDisturbance.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
  }

  void subTypeSelector() {
    if (selectedFF == "Flora") {
      subTypeInfo = subFlora;
      print("flora");
    } else if (selectedFF == "Fauna") {
      subTypeInfo = subFauna;
      print("fauna");
    } else {
      subTypeInfo = subDisturbance;
      print("floraS");
    }
    print("idostuff");
  }

  void setter() {
    setState(() {});
  }

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
          color: Colors.white,
          child: SizedBox(
            height: RouterConf.vArea,
            width: RouterConf.hArea,
            child: Stack(
              children: <Widget>[
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child: StreamBuilder(
                        stream: slr,
                        initialData: true,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data ==
                                DataConnectionStatus.disconnected) {
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
                          } else {
                            return Card(
                              elevation: _elevate,
                              child: Container(
                                height: 0,
                                width: 0,
                              ),
                            );
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
                                          stream: streamAlpha,
                                          builder: (context, snapshot) {
                                            return FittedBox(
                                              child: Text(
                                                snapshot.data.toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        RouterConf.blockH * 6),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: _defPad,
                                child: Container(
                                  width: _boxWidth,
                                  height: _boxHeight,
                                  child: IconButton(
                                    icon: Icon(Icons.autorenew),
                                    onPressed: () {},
                                    tooltip: "Sync progress now",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: _defPad,
                                child: Container(
                                  width: _boxWidth,
                                  height: _boxHeight,
                                  child: IconButton(
                                    icon: Icon(Icons.file_download),
                                    onPressed: () {},
                                    tooltip: "Null",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: _defPad,
                                child: Container(
                                  width: _boxWidth,
                                  height: _boxHeight,
                                  child: IconButton(
                                    icon: Icon(Icons.folder),
                                    onPressed: () {},
                                    tooltip: "My Submissions",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: RouterConf.blockV * 2,
                  right: RouterConf.blockH * 4,
                  child: Padding(
                    padding: _defPad2,
                    child: FloatingActionButton(
                      onPressed: () {
                        buttonbuilder(context);
                      },
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.spa),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buttonbuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        void setter2() {
          setState(() {
            i += 1;
            print("SetState2");
          });
        }

        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              FlatButton(
                child: Text(i.toString()),
                onPressed: setter2,
              )
              /* Padding(
                padding: _defPad2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: _defPad2,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: _defColor),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: _defColor,
                            child: DropdownButton(
                              value: selectedFF,
                              hint: Text(
                                "Type of Occurence",
                                style: TextStyle(
                                    fontSize: (RouterConf.blockV) * 1.9),
                              ),
                              items: ff,
                              onChanged: (val) {
                                selectedFF = val;
                                selectedSubType = null;
                                subTypeInfo = null;
                                subTypeSelector();
                                setState(() {
                                  
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: _defPad2,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: _defColor),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: _defColor,
                            child: DropdownButton(
                              value: selectedSubType,
                              hint: Text(
                                "Sub-Type",
                                style: TextStyle(
                                    fontSize: (RouterConf.blockV) * 1.9),
                              ),
                              items: subTypeInfo,
                              onChanged: (val) {
                                selectedSubType = val;
                                setter2();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), */
            ],
          ),
        );
      },
    );
  }
}
