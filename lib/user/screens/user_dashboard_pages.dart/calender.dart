import 'package:flutter/material.dart';

class UserCalender extends StatefulWidget {
  const UserCalender({Key? key}) : super(key: key);

  @override
  _UserCalenderState createState() => _UserCalenderState();
}

class _UserCalenderState extends State<UserCalender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calender"),
      ),
      body: Center(
        child: Text(
          "Calnder",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
