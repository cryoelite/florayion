import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import '../CollectorData/CollectorData.dart';

class MainRoute extends StatefulWidget {
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  var ffsubmitted;
  var speciesubmitted;
  var specieChecker = 0;
  String selectorff;
  String selectorSpecie;
  final enteredSpecie = TextEditingController();

  void collector() {
    var alpha = CollectorData(ffsubmitted, speciesubmitted);
    alpha.setter();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: GradientAppBar(
          gradient: Gradients.taitanum,
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
                style: TextStyle(fontSize: 26),
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          color: Colors.black,
          child: GradientCard(
            gradient: Gradients.taitanum,
            child: Column(
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
                      margin: EdgeInsets.only(top: 10, left: 5),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(canvasColor: Colors.white70),
                          child: DropdownButton(
                            value: selectorff,
                            hint: SizedBox(
                              width: 120,
                              height: 24,
                              child: Text(
                                "Type of Occurence",
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            items: CollectorData.ff
                                .map<DropdownMenuItem<String>>((val) {
                              return DropdownMenuItem<String>(
                                  child: Text(val), value: val);
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectorff = val;
                                ffsubmitted = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                      ),
                      child: SizedBox(
                        width: 180,
                        height: 48,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: specieChecker == 0
                                        ? "Specie Name"
                                        : "Already Exists !",
                                  ),
                                  controller: enteredSpecie,
                                  onSubmitted: (_) {
                                    final specieName = enteredSpecie.text;
                                    enteredSpecie.clear();
                                    if (!CollectorData.specie
                                        .contains(specieName)) {
                                      print("sss");
                                      specieChecker = 0;
                                      CollectorData.specie.add(specieName);
                                    } else {
                                      specieChecker = 1;
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: Colors.white70,
                              captureInheritedThemes: true,
                              icon: Icon(Icons.arrow_drop_down),
                              onSelected: (value) {
                                enteredSpecie.text = value;
                                speciesubmitted = value;
                              },
                              itemBuilder: (BuildContext context) {
                                return CollectorData.specie
                                    .map<PopupMenuItem<String>>((String val) {
                                  return PopupMenuItem<String>(
                                      child: Text(val), value: val);
                                }).toList();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GradientButton(
                      child: Text(
                        "Submit",
                      ),
                      callback: () {
                        collector();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
