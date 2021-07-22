import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class UserConnectionViewScreen extends StatefulWidget {
  const UserConnectionViewScreen({Key? key}) : super(key: key);

  @override
  _UserConnectionViewScreenState createState() =>
      _UserConnectionViewScreenState();
}

class _UserConnectionViewScreenState extends State<UserConnectionViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connections",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                ),
                title: Text("Parneet"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
