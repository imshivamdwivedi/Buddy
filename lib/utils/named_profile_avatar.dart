import 'package:flutter/material.dart';

class NamedProfileAvatar {
  List<Color> _colors = [
    Colors.pink,
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.lightGreen,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.black87,
    Colors.orange,
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
  ];

  Widget profileAvatar(String s) {
    return Container(
      height: 80.0,
      width: 80.0,
      child: CircleAvatar(
        backgroundColor:
            _colors[((s.toUpperCase().codeUnitAt(0) - 65) / 2).floor()],
        child: Text(
          s.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
