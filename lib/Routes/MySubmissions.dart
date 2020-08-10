import 'package:flutter/material.dart';
import '../routeConfig.dart';
import '../CollectorData/listData.dart';
import '../cust_icons_icons.dart';

class MySubs extends StatefulWidget {
  @override
  _MySubsState createState() => _MySubsState();
}

class _MySubsState extends State<MySubs> {
  List listData = [];
  final double _defHeight = (RouterConf.blockV) * 10;
  final double _defWidth = (RouterConf.blockH) * 80;
  final EdgeInsets _defPad = EdgeInsets.only(right: RouterConf.blockH * 8);

  final EdgeInsets _defPad2 = EdgeInsets.only(
      top: RouterConf.blockV * 0.5, bottom: RouterConf.blockV * 2);
  final _defColor = Colors.grey[200];
  final double _boxWidth = (RouterConf.blockH) * 15;
  final double _boxHeight = (RouterConf.blockV) * 8;

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
              ShaderMask(
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
                  "My Submissions",
                  style: TextStyle(fontSize: (RouterConf.blockV) * 4),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
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
                                    child:
                                        iconBuilder(listData[index]["FFType"]),
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
                                                "Type ",
                                              ),
                                              Text(
                                                listData[index]["FFType"],
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
                                                  "Details :",
                                                ),
                                                Text(
                                                  listData[index]["SpecieName"],
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
                                                "Sub: ",
                                              ),
                                              Text(
                                                listData[index]["Sub-Specie"],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: _boxWidth,
                                            height: _boxHeight,
                                            child: Row(
                                              children: [
                                                Text(" TT: "),
                                                Text(
                                                  listData[index]["Transect"]
                                                      .toString(),
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
            Text("Your Submissions will show up in a sec, if any exist."),
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
      return Icon(CustIcons.leaf);
    } else if (option == "Fauna") {
      return Icon(CustIcons.crow);
    } else if (option == "Reptiles") {
      return Icon(Icons.hdr_strong);
    } else {
      return Icon(CustIcons.shoe_prints);
    }
  }
}
