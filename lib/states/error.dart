import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Directionality(
          textDirection: TextDirection.ltr,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'Times',color:Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Error!', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )
      )
    ],);

  }
}