import 'dart:async';

import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:neumorphic/neumorphic.dart';

import '../routeConfig.dart';

class MBX extends StatefulWidget {
  final Stream<DataConnectionStatus> slr;
  MBX({Key key})
      : slr = DataConnectionChecker().onStatusChange,
        super(key: key);
  @override
  _MBXState createState() => _MBXState();
}

class _MBXState extends State<MBX> {
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
        body: NeuCard(
          height: RouterConf.blockV * 10,
          width: RouterConf.blockH * 100,
          curveType: CurveType.concave,
          bevel: 12,
          decoration: NeumorphicDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: StreamBuilder(
            stream: widget.slr,
            initialData: true,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("s");
              } else {
                return Text(snapshot.data.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
