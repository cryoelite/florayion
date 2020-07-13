import 'dart:async';

import 'package:florayion/CollectorData/GetLocalCollection.dart';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../routeConfig.dart';
import '../CreateDocCount.dart';
import '../CollectorData/SubmitToDBandFB.dart';
import '../CollectorData/moordb.dart';
import './MySubmissions.dart';
import '../Reset.dart';

class MBX extends StatefulWidget {
  @override
  _MBXState createState() => _MBXState();
}

class _MBXState extends State<MBX> {
  //Variables for streams
  final Stream<DataConnectionStatus> slr;
  final StreamController<int> str = StreamController();
  final StreamController<String> statusClr = StreamController();
  Stream statusStream;
  Timer timer;
  Timer statusTimer;
  Stream streamAlpha;

  _MBXState() : slr = DataConnectionChecker().onStatusChange {
    streamAlpha = str.stream;
    statusStream = statusClr.stream;
    getVal();
    mapper();
  }
  // Variables that manage layout
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
  static List<String> menuInfo = ["My Info", "LogOut", "Exit"];
  String menuValues;
  double _tempHeight = 0;
  double _tempWidth = 0;

  final _borRad = BorderRadius.circular(10);

  List<DropdownMenuItem> menuItems() {
    return menuInfo.map<DropdownMenuItem>((String val) {
      return subMapper(val);
    }).toList();
  }

  void canceller() {
    str.close();
    timer.cancel();
    statusClr.close();
    statusTimer.cancel();
  }

  void getVal() {
    statusTimer = Timer.periodic(Duration(minutes: 1), (_) => sendIntoDb());
    timer = Timer.periodic(Duration(seconds: 5), (_) async {
      str.sink.add(
        await CreateDocCount().getValue(),
      );
    });
  }

  void dispose() {
    canceller();
    filedb.close();
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
  final TextEditingController submitControl = TextEditingController();
  var specieList;
  final GetLocalCollection colDat = GetLocalCollection();
  final filedb = FDB();

  subMapper(var val) {
    var temp = DropdownMenuItem<String>(
        child: Text(
          val,
          style: TextStyle(fontSize: (RouterConf.blockV) * 1.9),
        ),
        value: val);

    return temp;
  }

  popMenuMapper() async {
    if (selectedFF != null && selectedSubType != null) {
      specieList = await colDat.getLocalCollection(selectedSubType, selectedFF);
      specieList = specieList.map<PopupMenuItem<String>>((var val) {
        return PopupMenuItem<String>(
            child: Text(val.toString(),
                style: TextStyle(fontSize: (RouterConf.blockV) * 1.9)),
            value: val);
      }).toList();
    } else {
      print("specie null");
      specieList = null;
    }
  }

  void mapper() {
    ff = colDat.ff.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
    subFlora = colDat.subTypeFlora.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
    subFauna = colDat.subTypeFauna.map<DropdownMenuItem<String>>((val) {
      return subMapper(val);
    }).toList();
    subDisturbance =
        colDat.subTypeDisturbance.map<DropdownMenuItem<String>>((val) {
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
      print("disturbance");
    }
  }

  void submit() async {
    if (selectedFF != null &&
        selectedSubType != null &&
        submitControl.text != "") {
      statusClr.sink.add("Saving Submission");
      final submitData = SubmitToDBandFB(
          tempff: selectedFF,
          tempSubSpecie: selectedSubType,
          tempSubmitVal: submitControl.text,
          filedb: filedb);
      await submitData.submitToDb();
      print("Sent submit from mainRoute");
      statusClr.sink.add("Idle");
    }
    resetter();
  }

  void resetter() {
    selectedSubType = null;
    selectedFF = null;
    specieList = null;
    submitControl.clear();
    setState(() {});
  }

  void sendIntoDb() async {
    statusClr.sink.add("Syncing Database");
    await SubmitToDBandFB().syncDBtoFireBase(filedb);
    statusClr.sink.add("Idle");
  }

  Future resetState(BuildContext context) async {
    await filedb.close();
    Reset().resetApp(context);
  }

  double animateHeight() {
    if (_tempHeight != 0) {
      _tempHeight = 0;
      return 0;
    } else {
      _tempHeight = _defHeight;
      return _tempHeight;
    }
  }

  double animateWidth() {
    if (_tempWidth != 0) {
      _tempWidth = 0;
      return _tempWidth;
    } else {
      _tempWidth = _defWidth;
      return _tempWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF19191a),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
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
              Container(
                child: Material(
                  color: Colors.transparent,
                  child: DropdownButton(
                    underline: Container(),
                    iconEnabledColor: Colors.white,
                    icon: Icon(Icons.menu),
                    items: menuItems(),
                    value: menuValues,
                    onChanged: (val) {
                      if (val == menuInfo[1]) {
                        resetState(context);
                      } else if (val == menuInfo[2]) {
                        SystemNavigator.pop();
                      }
                    },
                  ),
                ),
              ),
            ],
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
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: _boxWidth,
                                    height: _boxHeight,
                                    child: InkWell(
                                      enableFeedback: true,
                                      excludeFromSemantics: true,
                                      child: IconButton(
                                        color: Colors.black,
                                        icon: Icon(Icons.autorenew),
                                        onPressed: () {
                                          sendIntoDb();
                                        },
                                        tooltip: "Sync progress now",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text("|"),
                              Padding(
                                padding: _defPad,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: _boxWidth,
                                    height: _boxHeight,
                                    child: IconButton(
                                      icon: Icon(Icons.info_outline),
                                      onPressed: () {
                                        /* setState(() {}); */
                                      },
                                      tooltip: "Info",
                                    ),
                                  ),
                                ),
                              ),
                              Text("|"),
                              Padding(
                                padding: _defPad,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: _boxWidth,
                                    height: _boxHeight,
                                    child: IconButton(
                                      icon: Icon(Icons.folder),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MySubs(),
                                          ),
                                        );
                                      },
                                      tooltip: "My Submissions",
                                    ),
                                  ),
                                ),
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
                            height: _defHeight,
                            width: _defWidth,
                            color: _defColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: _defPad,
                                  child: Text(
                                    "Status :  ",
                                    style: TextStyle(
                                        fontSize: RouterConf.blockV * 3),
                                  ),
                                ),
                                Padding(
                                  padding: _defPad,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: RouterConf.blockH * 0.6,
                                      ),
                                    ),
                                    child: StreamBuilder(
                                      stream: statusStream,
                                      builder: (_, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            snapshot.connectionState ==
                                                ConnectionState.none) {
                                          return defaultStatus();
                                        } else {
                                          return defaultStatus(
                                              val: snapshot.data);
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
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

  Widget defaultStatus({String val = "Idle"}) {
    return Container(
      width: _boxWidth,
      height: _boxHeight,
      child: Center(
        child: Text(
          val,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: RouterConf.blockV * 2),
        ),
      ),
    );
  }

  buttonbuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Input Details",
            ),
          ),
          content: StatefulBuilder(builder: (
            context,
            StateSetter setState,
          ) {
            return Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Padding(
                  padding: _defPad2,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: _defPad2,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: _defColor),
                            child: ClipRRect(
                              borderRadius: _borRad,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      "Type Of Occurence",
                                      style: TextStyle(
                                        fontSize: (RouterConf.blockV) * 1.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: _defColor,
                                    child: Padding(
                                      padding: _defPad,
                                      child: DropdownButton(
                                        hint: Padding(
                                          padding: _defPad,
                                          child: Text(
                                            "Select Here: ",
                                            style: TextStyle(
                                                fontSize:
                                                    (RouterConf.blockV) * 1.9),
                                          ),
                                        ),
                                        value: selectedFF,
                                        items: ff,
                                        onChanged: (val) {
                                          selectedFF = val;
                                          selectedSubType = null;
                                          subTypeInfo = null;
                                          subTypeSelector();
                                          popMenuMapper();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
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
                              borderRadius: _borRad,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      "Sub-Type",
                                      style: TextStyle(
                                        fontSize: (RouterConf.blockV) * 1.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: _defColor,
                                    child: Padding(
                                      padding: _defPad,
                                      child: DropdownButton(
                                        hint: Padding(
                                          padding: _defPad,
                                          child: Text(
                                            "Select Here: ",
                                            style: TextStyle(
                                                fontSize:
                                                    (RouterConf.blockV) * 1.9),
                                          ),
                                        ),
                                        value: selectedSubType,
                                        items: subTypeInfo,
                                        onChanged: (val) {
                                          selectedSubType = val;
                                          popMenuMapper();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
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
                              borderRadius: _borRad,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      "Select one of the options or type your own",
                                      style: TextStyle(
                                        fontSize: (RouterConf.blockV) * 1.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: _defColor,
                                    width: RouterConf.blockH * 60,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: _defPad,
                                          child: Container(
                                            width: RouterConf.blockH * 45,
                                            child: TextField(
                                              controller: submitControl,
                                            ),
                                          ),
                                        ),
                                        specieList != null
                                            ? Container(
                                                width: RouterConf.blockH * 4,
                                                child: PopupMenuButton<String>(
                                                  padding: EdgeInsets.all(2),
                                                  enabled: true,
                                                  onSelected: (val) {
                                                    print(
                                                        "Selected Pop button");
                                                    submitControl.text = val;
                                                  },
                                                  captureInheritedThemes: true,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    return specieList;
                                                  },
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: RouterConf.blockV * 5,
                          width: RouterConf.blockH * 20,
                          child: GradientButton(
                            child: Text(
                              "Submit",
                            ),
                            callback: () {
                              submit();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
