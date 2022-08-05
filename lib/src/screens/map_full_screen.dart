import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class MapFullScreen extends StatefulWidget {
  const MapFullScreen({Key? key}) : super(key: key);

  @override
  State<MapFullScreen> createState() => _MapFullScreenState();
}

class _MapFullScreenState extends State<MapFullScreen> {
  MapboxMapController? mapController;
  final center = LatLng(21.085282295062417, -101.62745545740576);
  final darkStyle = 'mapbox://styles/saulrmz360/cl6g1snhc003314rrar6tllin';
  final streetsStyle = 'mapbox://styles/saulrmz360/cl6g1w2c3001p14msg0y7i48i';
  String selectedStyle = 'mapbox://styles/saulrmz360/cl6g1snhc003314rrar6tllin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: Platform.isAndroid ? 'TOKEN_HERE' : null,
        styleString: selectedStyle,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 14),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              mapController!.addSymbol(SymbolOptions(
                  geometry: center,
                  //iconSize: 5,
                  textField: 'Agregaste un puntero',
                  iconImage: 'networkImage',
                  textOffset: Offset(0, 2)));
            },
            child: Icon(Icons.location_on),
          ),
          SizedBox(height: 5),
          FloatingActionButton(
            onPressed: () {
              mapController!.animateCamera(CameraUpdate.zoomIn());
            },
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(height: 5),
          FloatingActionButton(
            onPressed: () {
              mapController!.animateCamera(CameraUpdate.zoomOut());
            },
            child: Icon(Icons.zoom_out),
          ),
          SizedBox(height: 5),
          FloatingActionButton(
            onPressed: () {
              _onStyleLoaded();
              setState(() {
                selectedStyle =
                    selectedStyle == darkStyle ? streetsStyle : darkStyle;
              });
            },
            child: Icon(Icons.layers),
          ),
        ],
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/flutter.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController!.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(Uri.parse(url));
    return mapController!.addImage(name, response.bodyBytes);
  }
}
