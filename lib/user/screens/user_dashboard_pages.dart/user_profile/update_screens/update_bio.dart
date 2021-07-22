import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class updateBioScreen extends StatefulWidget {
  const updateBioScreen({Key? key}) : super(key: key);

  @override
  _updateBioScreenState createState() => _updateBioScreenState();
}

class _updateBioScreenState extends State<updateBioScreen> {
  final TextEditingController _bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: kPrimaryColor,
          title: Text("Update Bio", style: TextStyle(color: Colors.black87))),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: size.height * 0.2),
            child: Center(
              child: Column(children: [
                TextArea(
                    text: "Edit Bio",
                    controller: _bioController,
                    sizeRatio: 0.9),
                RoundedButton(
                    size,
                    0.4,
                    Text(
                      "Update",
                      style: TextStyle(color: Colors.black),
                    ),
                    () {},
                    ''),
              ]),
            )),
      ),
    );
  }
}
