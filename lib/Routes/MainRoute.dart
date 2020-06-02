import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../CollectorData/CollectorData.dart';
import 'package:florayion/CollectorData/SubmitterData.dart';
import '../routeConfig.dart';

class MainRoute extends StatefulWidget {
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  var i = 0;

  var specieList;
  var tempSS;
  var ffsubmitted;
  var subSpecieSubmitted;
  String selectorSS;
  String selectorff;
  final enteredSpecie = TextEditingController();
  final fetchData = CollectorData();

  void collector() {
    final submitData = SubmitterData(
        tempff: ffsubmitted,
        tempSubSpecie: subSpecieSubmitted,
        tempsubmitVal: enteredSpecie.text);
    submitData.setter();
    enteredSpecie.clear();
    subSpecieSubmitted = null;
    ffsubmitted = null;
    selectorSS = null;
    selectorff = null;
    specieList = null;
    i = 0;
  }

  initiator() async {
    specieList = await fetchData.getFFSpecie(subSpecieSubmitted,
        ffsubmitted != "Flora" && ffsubmitted != "Disturbance" ? 1 : 0);
    specieList = specieList.map<PopupMenuItem<String>>((dynamic val) {
      return PopupMenuItem<String>(
          child:
              Text(val, style: TextStyle(fontSize: (RouterConf.blockV) * 1.9)),
          value: val);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    RouterConf().init(context);
    return Material(
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
                "GTF",
                style: TextStyle(fontSize: (RouterConf.blockV) * 4),
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity, 
          decoration: BoxDecoration(color: Colors.black,
            image: DecorationImage(
              image: AssetImage(
                'lib/ImageAsset/ppo2.jpg',
              ),
            ),
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        child: SizedBox(
                          width: 1,
                          height: 1,
                        ),
                      ),
                      Card(
                        color: Colors.white70,
                        margin: EdgeInsets.only(
                            top: (RouterConf.blockV) * 1.4,
                            left: (RouterConf.blockV) * 0.8),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.white70),
                            child: SizedBox(
                              width: (RouterConf.blockV) * 22,
                              height: (RouterConf.blockV) * 6.4,
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  DropdownButton(
                                    value: selectorff,
                                    hint: Text(
                                      "Type of Occurence",
                                      style: TextStyle(
                                          fontSize: (RouterConf.blockV) * 1.9),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    items: CollectorData.ff
                                        .map<DropdownMenuItem<String>>((val) {
                                      return DropdownMenuItem<String>(
                                          child: Text(
                                            val,
                                            style: TextStyle(
                                                fontSize:
                                                    (RouterConf.blockV) * 1.9),
                                          ),
                                          value: val);
                                    }).toList(),
                                    onChanged: (val) {
                                      selectorff = val;
                                      ffsubmitted = val;
                                      tempSS = subspecieType();
                                      if (selectorSS != null) {
                                        selectorSS = null;
                                        subSpecieSubmitted = null;
                                        enteredSpecie.text = "";
                                      }
                                      if (enteredSpecie.text != null) {
                                        enteredSpecie.clear();
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Card(
                        color: Colors.white70,
                        margin: EdgeInsets.only(
                          top: (RouterConf.blockV) * 15,
                          left: (RouterConf.blockV) * 2.8,
                        ),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.white70),
                            child: SizedBox(
                              width: (RouterConf.blockV) * 20,
                              height: (RouterConf.blockV) * 6.4,
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  DropdownButton(
                                    value: selectorSS,
                                    hint: Text(
                                      "Sub-Specie Type",
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    items: tempSS,
                                    onChanged: (val) {
                                      enteredSpecie.text = "";
                                      selectorSS = val;
                                      subSpecieSubmitted = val;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Card(
                        color: Colors.white70,
                        margin: EdgeInsets.only(
                          top: (RouterConf.blockV) * 15,
                          left: (RouterConf.blockV) * 2.8,
                        ),
                        child: SizedBox(
                          width: (RouterConf.blockV) * 38,
                          height: (RouterConf.blockV) * 6,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: (RouterConf.blockV) * 1),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: ffsubmitted != "Disturbance"
                                            ? "Specie Names"
                                            : "Please describe the disturbance",
                                        hintStyle: TextStyle(
                                            fontSize:
                                                (RouterConf.blockV) * 1.9)),
                                    controller: enteredSpecie,
                                    onSubmitted: (_) {},
                                  ),
                                ),
                              ),
                              (ffsubmitted != null &&
                                      subSpecieSubmitted != null &&
                                      ffsubmitted != "Disturbance")
                                  ? FutureBuilder(
                                      future: initiator(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData == null &&
                                            snapshot.connectionState ==
                                                ConnectionState.none) {
                                          return Container();
                                        }
                                        return PopupMenuButton<String>(
                                          color: Colors.white70,
                                          captureInheritedThemes: true,
                                          icon: Icon(Icons.arrow_drop_down),
                                          onSelected: (value) {
                                            enteredSpecie.text = value;
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return specieList;
                                          },
                                        );
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  submitHere(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checker() {
    if (((subSpecieSubmitted != null && ffsubmitted != null) ||
            (ffsubmitted == "Disturbance")) &&
        (enteredSpecie.text != null && enteredSpecie.text != "")) {
      setState(() {
        i = 0;
      });
    } else {
      setState(() {
        i = 1;
      });
    }
  }

  Widget submitHere() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: i == 1
              ? Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Please complete the form",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: GradientButton(
                        child: Text(
                          "Submit",
                        ),
                        callback: () {
                          checker();
                          if (i == 0) {
                            collector();
                          }
                        },
                      ),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: GradientButton(
                        child: Text(
                          "Submit",
                        ),
                        callback: () {
                          checker();
                          if (i == 0) {
                            collector();
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  subspecieType() {
    if (selectorff == "Flora") {
      return CollectorData.subTypeFlora.map<DropdownMenuItem<String>>((val) {
        return DropdownMenuItem<String>(
            child: Text(
              val,
              style: TextStyle(
                fontSize: (RouterConf.blockV) * 1.9,
              ),
            ),
            value: val);
      }).toList();
    } else if (selectorff == "Fauna") {
      return CollectorData.subTypeFauna.map<DropdownMenuItem<String>>((val) {
        return DropdownMenuItem<String>(
            child: Text(
              val,
              style: TextStyle(
                fontSize: (RouterConf.blockV) * 1.9,
              ),
            ),
            value: val);
      }).toList();
    }
  }
}
