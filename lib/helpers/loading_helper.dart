import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading_Helper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: SpinKitCubeGrid(
            color: Colors.black,
            size: 50.0,
          ))),
    );
  }
}
