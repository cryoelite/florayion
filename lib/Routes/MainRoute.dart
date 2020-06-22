import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

import '../routeConfig.dart';

class MBX extends StatefulWidget {
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
          curveType: CurveType.concave,
          color: Colors.amber,
          bevel: 12,
          decoration: NeumorphicDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Hi",
          ),
        ),
      ),
    );
  }
}
