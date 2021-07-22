import 'package:buddy/chat/screens/group_detail_screen.dart';
import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(GroupDetailScreen.routeName);
          },
          child: Text(
            "e-Cell 2020-2021",
            style: TextStyle(color: Colors.black),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
