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

  Widget profileAvatar(String s, double hw) {
    int index = (s.toUpperCase().codeUnits[0] - 65);
    return Container(
      height: hw,
      width: hw,
      child: CircleAvatar(
        backgroundColor:
            (index > -1 && index < 26) ? _colors[index] : Colors.grey,
        child: Text(
          s.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: hw / 2,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
