import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class CommunityViewScreen extends StatefulWidget {
  const CommunityViewScreen({Key? key}) : super(key: key);

  @override
  _CommunityViewScreenState createState() => _CommunityViewScreenState();
}

class _CommunityViewScreenState extends State<CommunityViewScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Community",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: size.height * 0.05),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                ),
                title: Text("java"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
