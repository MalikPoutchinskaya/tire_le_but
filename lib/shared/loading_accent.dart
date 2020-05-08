import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAccent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent[100],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.deepOrangeAccent,
          size: 50.0,
        ),
      ),
    );
  }
}