import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Utilities/routeConfig.dart';

class MapImplementation extends StatefulWidget {
  MapImplementation({Key key}) : super(key: key);
  final _MapImplementationState mp=_MapImplementationState();
  @override
  _MapImplementationState createState() => mp;
}

class _MapImplementationState extends State<MapImplementation> {
  //MapImplementation
  GoogleMapController mapclr;
  LatLng position;
  List<LatLng> markerPoints = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

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
    setState(() {});
  }

  Future<LatLng> positioner() async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(
        "Positioner | Current Position : [${pos.latitude}],[${pos.longitude}]");
    position = LatLng(pos.latitude, pos.longitude);
    return position;
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
