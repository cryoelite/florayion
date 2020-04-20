import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class MainRoute extends StatefulWidget {
  final List<DropdownMenuItem<String>> ff = [
    DropdownMenuItem<String>(
      child: Text(
        "Flora",
      ),
      value: "Flora",
    ),
    DropdownMenuItem<String>(
      child: Text("Fauna"),
      value: "Fauna",
    )
  ];

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  String selector;
  void collector() {}
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  color: Colors.grey,
                  margin: EdgeInsets.only(top: 10),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: Colors.grey),
                        child: DropdownButton(
                          value: selector,
                          hint: Text(
                            "Type of Occurence",
                          ),
                          style: TextStyle(color: Colors.black),
                          items: widget.ff,
                          onChanged: (val) {
                            selector = val;
                            setState(() {});
                          },
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
    );
  }
}
