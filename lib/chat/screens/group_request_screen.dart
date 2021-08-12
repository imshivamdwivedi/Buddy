import 'package:flutter/material.dart';

class GroupRequestScreen extends StatefulWidget {
  const GroupRequestScreen({Key? key}) : super(key: key);

  @override
  _GroupRequestScreenState createState() => _GroupRequestScreenState();
}

class _GroupRequestScreenState extends State<GroupRequestScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Requests",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: size.height - kToolbarHeight,
      ),
    );
  }
}
