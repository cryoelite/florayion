import 'package:flutter/material.dart';
import '../Utilities/routeConfig.dart';
import '../CollectorData/listData.dart';
import '../cust_icons_icons.dart';
import 'package:flare_flutter/flare_actor.dart';

class MySubsHindi extends StatefulWidget {
  @override
  _MySubsHindiState createState() => _MySubsHindiState();
}

class _MySubsHindiState extends State<MySubsHindi> {
  List listData = [];
  final double _defHeight = (RouterConf.blockV) * 10;
  final double _defWidth = (RouterConf.blockH) * 80;
  final EdgeInsets _defPad = EdgeInsets.only(right: RouterConf.blockH * 8);

  final EdgeInsets _defPad2 = EdgeInsets.only(
      top: RouterConf.blockV * 0.5, bottom: RouterConf.blockV * 2);
  final _defColor = Color(0xFF78D5FF);
  final double _boxWidth = (RouterConf.blockH) * 15;
  final double _boxHeight = (RouterConf.blockV) * 8;
  final TextStyle _defStyle = TextStyle(
    fontSize: RouterConf.blockH * 3.6,
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
  Future initList() async {
    listData = await ListData().getList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color(0xFF19191a),
          title: Row(
            children: <Widget>[
              Padding(
                padding: _defPad,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(
                    context,
                  ),
                ),
              ),
              /* ShaderMask(
                shaderCallback: (bounds) => RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: [
                    Color(0xFF1BCEEC),
                    Color(0xFF78D5FF),
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(bounds),
                
              ), */
              Text(
                "मेरी प्रस्तुतियाँ",
                style: TextStyle(
                  fontSize: (RouterConf.blockV) * 4,
                  color: Color(
                    0xFF78D5FF,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Color(0xFF1BCEEC),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: RouterConf.hArea,
                height: RouterConf.vArea,
                child: FlareActor(
                  'lib/Animations/BackGroundForked.flr',
                  animation: "Background Loop",
                  fit: BoxFit.fill,
                ),
              ),
              FutureBuilder(
                future: initList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (listData.length != 0) {
                      return Container(
                        child: ListView.builder(
                          itemCount: listData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: _defPad2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Card(
                                  elevation: 5,
                                  child: new Container(
                                      color: _defColor,
                                      width: _defWidth,
                                      height: _defHeight,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: _boxWidth,
                                            height: _boxHeight,
                                            child: iconBuilder(
                                                listData[index]["FFType"]),
                                          ),
                                          Container(
                                            width: RouterConf.blockH * 45,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: _defPad2,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "प्रकार: ",
                                                        style: _defStyle,
                                                      ),
                                                      Text(
                                                        listData[index]
                                                            ["FFType"],
                                                        style: _defStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: _defPad2,
                                                  child: FittedBox(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          "विवरण: ",
                                                          style: _defStyle,
                                                        ),
                                                        Text(
                                                          listData[index]
                                                              ["SpecieName"],
                                                          style: _defStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: RouterConf.blockH * 30,
                                            child: FittedBox(
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "विषय: ",
                                                        style: _defStyle,
                                                      ),
                                                      Text(
                                                        listData[index]
                                                            ["Sub-Specie"],
                                                        style: _defStyle,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: _boxWidth,
                                                    height: _boxHeight,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "लाइन: ",
                                                          style: _defStyle,
                                                        ),
                                                        Text(
                                                          listData[index]
                                                                  ["Transect"]
                                                              .toString(),
                                                          style: _defStyle,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return buildContainer();
                    }
                  } else {
                    return buildContainer();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer() {
    return Container(
      color: Colors.white,
      width: RouterConf.hArea,
      height: RouterConf.vArea,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("यदि कोई मौजूद है तो आपका सबमिशन एक सेकंड में दिखाई देगा।"),
            Icon(
              CustIcons.crow,
            ),
          ],
        ),
      ),
    );
  }

  Icon iconBuilder(String option) {
    if (option == "Flora") {
      return Icon(
        CustIcons.leaf,
        color: Colors.white,
      );
    } else if (option == "Fauna") {
      return Icon(
        CustIcons.crow,
        color: Colors.white,
      );
    } else if (option == "Reptiles") {
      return Icon(
        Icons.hdr_strong,
        color: Colors.white,
      );
    } else {
      return Icon(
        CustIcons.shoe_prints,
        color: Colors.white,
      );
    }
  }
}
