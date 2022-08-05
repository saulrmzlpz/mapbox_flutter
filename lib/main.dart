import 'package:flutter/material.dart';
import 'package:mapbox_flutter/src/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(body: MapFullScreen()),
    );
  }
}
