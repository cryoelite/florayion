import 'dart:async';

import 'package:florayion/CollectorData/GetLocalCollection.dart';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../Utilities/routeConfig.dart';
import '../Utilities/CreateDocCount.dart';
import '../CollectorData/SubmitToDBandFB.dart';
import '../CollectorData/moordb.dart';
import './MySubmissions.dart';

import '../Utilities/Reset.dart';
import '../CollectorData/transectState.dart';
import '../LoginData/LocalUserData.dart';

enum SyncState {
  START,
  END,
}

enum UpdateState {
  ON,
  OFF,
}

class MBX extends StatefulWidget {
  @override
  _MBXState createState() => _MBXState();
}

class _MBXState extends State<MBX> {
  //MapData
  GoogleMapController mapclr;
  LatLng position;
  List<LatLng> markerPoints = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  StateSetter mapState;

  Future markerUpdate() async {
    final LatLng pos = await positioner();
    final Marker marker = Marker(
      markerId: MarkerId("one"),
      position: pos,
      icon: BitmapDescriptor.defaultMarkerWithHue(23),
    );
    markers.add(marker);
    markerPoints.add(pos);

    print("Polylines");
    polylines.add(
      Polyline(
        polylineId: PolylineId("value"),
        geodesic: true,
        points: markerPoints,
        color: Colors.indigo[400],
        width: (RouterConf.blockV * 0.6).toInt(),
      ),
    );
  }

  Widget mapData(BuildContext context) {
    print("mapData started");
    return Container(
      child: GoogleMap(
        onMapCreated: (GoogleMapController tempclr) {
          mapclr = tempclr;
        },
        myLocationEnabled: true,
        markers: markers,
        polylines: polylines,
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 13.0,
        ),
      ),
    );
  }

  void resetMarker() {
    markerPoints = [];
    markers = {};
    polylines = {};
    mapState(() {});
  }

  Future<LatLng> positioner() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(
        "Positioner | Current Position : [${pos.latitude}],[${pos.longitude}]");
    position = LatLng(pos.latitude, pos.longitude);
    return position;
  }

  Widget mapImplementation(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter stateSetter) {
      mapState = stateSetter;
      return Container(
        width: RouterConf.blockH * 80,
        height: RouterConf.blockV * 40,
        child: FutureBuilder(
          future: positioner(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return mapData(context);
            } else {
              return Container();
            }
          },
        ),
      );
    });
  }

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
      top: RouterConf.blockV * 0.2, bottom: RouterConf.blockV * 1.4);
  final _defColor = Color(0xEA78D5FF);
  final double _boxWidth = (RouterConf.blockH) * 20;
  final double _boxHeight = (RouterConf.blockV) * 8;
  static List<String> menuInfo = ["Language", "LogOut", "Exit"];
  TextStyle _defStyle2 = TextStyle(
    fontSize: (RouterConf.blockV) * 1.9,
    fontWeight: FontWeight.w700,
    fontFamily: "Lato",
    color: Colors.white,
  );
  String menuValues;
  double _tempHeight = 0;
  double _tempWidth = 0;
  final TextStyle _defStyle = TextStyle(
    fontSize: RouterConf.blockH * 5,
    color: Colors.white,
    fontFamily: "Lato",
    fontWeight: FontWeight.w700,
    shadows: <Shadow>[
      Shadow(
        blurRadius: RouterConf.blockH * 1,
        color: Colors.black,
      ),
    ],
  );

  final _borRad = BorderRadius.circular(10);

  List<DropdownMenuItem> menuItems() {
    return menuInfo.map<DropdownMenuItem>((String val) {
      return subMapper(val);
    }).toList();
  }

  void canceller() {
    statusTimer.cancel();
    timer.cancel();
    str.close();

    statusClr.close();
  }

  void getVal() {
    statusTimer =
        Timer.periodic(Duration(minutes: 1), (_) {}); // => sendIntoDb());
    timer = Timer.periodic(Duration(seconds: 5), (_) async {
      if (await DataConnectionChecker().hasConnection == true) {
        str.sink.add(
          await CreateDocCount().getValue(),
        );
      }
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
  int transectCount = 1;
  final filedb = FDB();
  SyncState syncState = SyncState.START;
  UpdateState updateState = UpdateState.OFF;
  String lang = "English";

  Future<void> transectState(BuildContext context) async {
    final Map<bool, int> value = await TransectState().getTransectState;
    transectCount = value.values.first;
    if (value.keys.first) {
      final provider =
          Provider.of<ValueNotifier<UpdateState>>(context, listen: false);
      final provider2 =
          Provider.of<ValueNotifier<SyncState>>(context, listen: false);
      provider2.value = SyncState.END;
      provider.value = UpdateState.ON;
    }
  }

  subMapper(var val) {
    var temp = DropdownMenuItem<String>(
        child: Text(
          val,
          style: _defStyle2,
        ),
        value: val);

    return temp;
  }

  popMenuMapper() async {
    if (selectedFF != null && selectedSubType != null) {
      specieList = await colDat.getLocalCollection(selectedSubType, selectedFF);
      specieList = specieList.map<PopupMenuItem<String>>((var val) {
        return PopupMenuItem<String>(
            child: Text(
              val.toString(),
              style: _defStyle2,
            ),
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

  Future checkLogin() async {
    if (await UserDetails.checker() != 1) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/first',
        (_) => false,
      );
    }
  }

  Future submit() async {
    if (selectedFF != null &&
        selectedSubType != null &&
        submitControl.text != "") {
      statusClr.sink.add("Saving Submission");
      final submitData = SubmitToDBandFB(
        tempff: selectedFF,
        tempSubSpecie: selectedSubType,
        tempSubmitVal: submitControl.text,
        filedb: filedb,
        transect: transectCount,
      );
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

  Future sendIntoDb() async {
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

  Future setLang() async {
    await UserDetails().setLang(lang);
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /*Container(
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
              ), */

              Container(
                child: Material(
                  color: Colors.transparent,
                  child: DropdownButton(
                    dropdownColor: _defColor,
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
                      } else {
                        resetter();
                        filedb.close();

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/fifth',
                          (_) => false,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            future: setLang(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  color: Color(0xFF1BCEEC),
                  child: SizedBox(
                    height: RouterConf.vArea,
                    width: RouterConf.hArea,
                    child: buildStack(context),
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Stack buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: RouterConf.hArea,
          height: RouterConf.vArea,
          child: FlareActor(
            'lib/Animations/BackGroundForked.flr',
            animation: "Background Loop",
            fit: BoxFit.fill,
          ),
        ),
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
                    if (snapshot.data == DataConnectionStatus.disconnected) {
                      return Padding(
                        padding: _defPad2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
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
                                      size: RouterConf.blockH * 8,
                                    ),
                                  ),
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      " Please Check Connectivity !",
                                      style: _defStyle,
                                    ),
                                  ),
                                ],
                              ),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Card(
                  elevation: _elevate,
                  child: Container(
                    color: _defColor,
                    height: _defHeight,
                    width: _defWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: _defPad,
                          child: Text(
                            "SUBMISSIONS: ",
                            style: _defStyle,
                          ),
                        ),
                        Padding(
                          padding: _defPad,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: RouterConf.blockH * 10,
                              width: RouterConf.blockV * 6,
                              child: Container(
                                /*  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: RouterConf.blockH * 0.6,
                                  ),
                                ), */
                                child: Center(
                                  child: StreamBuilder<int>(
                                    stream: streamAlpha,
                                    builder: (context, snapshot) {
                                      return FittedBox(
                                        child: Text(
                                          snapshot.data.toString(),
                                          style: _defStyle,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: _defPad2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Card(
                  elevation: _elevate,
                  child: Container(
                    width: _defWidth,
                    height: _defHeight,
                    color: _defColor,
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider<ValueNotifier<SyncState>>(
                          create: (_) => ValueNotifier<SyncState>(syncState),
                        ),
                        ChangeNotifierProvider<ValueNotifier<UpdateState>>(
                          create: (_) =>
                              ValueNotifier<UpdateState>(updateState),
                        ),
                      ],
                      child: Builder(
                        builder: (context) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildSyncButton(context),
                            Text("|"),
                            buildUpdateButton(context),
                            Text("|"),
                            Padding(
                              padding: _defPad,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  width: _boxWidth,
                                  height: _boxHeight,
                                  child: IconButton(
                                    iconSize: RouterConf.blockH * 10,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.folder,
                                      color: Colors.white,
                                    ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: _defPad,
                        child: Text(
                          "STATUS: ",
                          style: _defStyle,
                        ),
                      ),
                      Padding(
                        padding: _defPad,
                        child: Container(
                          /* decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.black,
                              width: RouterConf.blockH * 0.6,
                            ),
                          ), */
                          child: StreamBuilder(
                            stream: statusStream,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.connectionState ==
                                      ConnectionState.none) {
                                return defaultStatus();
                              } else {
                                return defaultStatus(val: snapshot.data);
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: _defPad2,
              child: mapImplementation(context),
            )
          ],
        ),
      ],
    );
  }

  Widget buildUpdateButton(BuildContext context) {
    return Consumer<ValueNotifier<UpdateState>>(
      builder: (_, value, __) {
        return Padding(
          padding: _defPad,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: _boxWidth,
              height: _boxHeight - 20,
              child: value.value == UpdateState.OFF
                  ? IconButton(
                      iconSize: RouterConf.blockH * 10,
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.sync,
                        color: Colors.grey[800],
                      ),
                      onPressed: () {},
                    )
                  : IconButton(
                      iconSize: RouterConf.blockH * 10,
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.sync,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await buttonbuilder(context);
                        await markerUpdate();
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSyncButton(BuildContext context) {
    return FutureBuilder(
      future: transectState(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<ValueNotifier<SyncState>>(
            builder: (__, value, _) {
              return Padding(
                padding: _defPad,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: _boxWidth,
                    height: _boxHeight - 20,
                    child: InkWell(
                      enableFeedback: true,
                      excludeFromSemantics: true,
                      child: value.value == SyncState.START
                          ? IconButton(
                              iconSize: RouterConf.blockH * 10,
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.flag,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await Future.sync(() => checkLogin());
                                value.value = SyncState.END;

                                Map<bool, int> map = {true: transectCount};
                                await TransectState().setTransectState(map);
                                final updateProvider =
                                    Provider.of<ValueNotifier<UpdateState>>(
                                        context,
                                        listen: false);
                                updateProvider.value = UpdateState.ON;
                                await markerUpdate();
                              },
                            )
                          : IconButton(
                              iconSize: RouterConf.blockH * 10,
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.flag,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                value.value = SyncState.START;
                                await sendIntoDb();
                                resetMarker();
                                transectCount += 1;
                                Map<bool, int> map = {false: transectCount};
                                await TransectState().setTransectState(map);
                                final updateProvider =
                                    Provider.of<ValueNotifier<UpdateState>>(
                                        context,
                                        listen: false);
                                updateProvider.value = UpdateState.OFF;
                              },
                            ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container(
            color: Colors.white,
          );
        }
      },
    );
  }

  Widget defaultStatus({String val = "Idle"}) {
    return Container(
      width: _boxWidth,
      height: _boxHeight,
      child: Center(
        child: Text(
          val,
          style: _defStyle,
        ),
      ),
    );
  }

  buttonbuilder(BuildContext context) {
    Color _defColor2 = Color(0xEA1BCEEC);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _defColor,
          title: Center(
            child: Text(
              "Input Details",
              style: _defStyle,
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
                                .copyWith(canvasColor: _defColor2),
                            child: ClipRRect(
                              borderRadius: _borRad,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      "Type Of Occurence",
                                      style: _defStyle2,
                                    ),
                                  ),
                                  Container(
                                    color: _defColor2,
                                    child: Padding(
                                      padding: _defPad,
                                      child: DropdownButton(
                                        hint: Padding(
                                          padding: _defPad,
                                          child: Text(
                                            "Select Here: ",
                                            style: _defStyle2,
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
                                .copyWith(canvasColor: _defColor2),
                            child: ClipRRect(
                              borderRadius: _borRad,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      "Sub-Type",
                                      style: _defStyle2,
                                    ),
                                  ),
                                  Container(
                                    color: _defColor2,
                                    child: Padding(
                                      padding: _defPad,
                                      child: DropdownButton(
                                        hint: Padding(
                                          padding: _defPad,
                                          child: Text(
                                            "Select Here: ",
                                            style: _defStyle2,
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
                                .copyWith(canvasColor: _defColor2),
                            child: ClipRRect(
                              borderRadius: _borRad,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: _defPad,
                                    child: Text(
                                      "Select one of the options or type your own",
                                      style: _defStyle2,
                                    ),
                                  ),
                                  Container(
                                    color: _defColor2,
                                    width: RouterConf.blockH * 60,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: _defPad,
                                          child: Container(
                                            width: RouterConf.blockH * 45,
                                            child: TextField(
                                              controller: submitControl,
                                              style: _defStyle2,
                                            ),
                                          ),
                                        ),
                                        specieList != null
                                            ? Container(
                                                width: RouterConf.blockH * 4,
                                                child: PopupMenuButton<String>(
                                                  color: _defColor,
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
                        Padding(
                          padding: _defPad2,
                          child: Container(
                            child: Text(
                              "Current Transect: $transectCount",
                              style: _defStyle2,
                            ),
                          ),
                        ),
                        Container(
                          height: RouterConf.blockV * 5,
                          width: RouterConf.blockH * 20,
                          child: GradientButton(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue[800],
                                Colors.black,
                              ],
                            ),
                            child: Text(
                              "Submit",
                            ),
                            callback: () async {
                              await submit();
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
