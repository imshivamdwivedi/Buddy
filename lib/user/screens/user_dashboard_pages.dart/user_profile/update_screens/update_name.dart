import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class UpdateName extends StatefulWidget {
  const UpdateName({Key? key}) : super(key: key);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _firstName = new TextEditingController();
    final TextEditingController _secondName = new TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: kPrimaryColor,
          title: Text("Update Name", style: TextStyle(color: Colors.black87))),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: Center(
            child: Column(
              children: [
                RoundedInputField(text: "First Name", controller: _firstName),
                RoundedInputField(text: "Second Name", controller: _secondName),
                RoundedButton(
                    size,
                    0.4,
                    Text(
                      "Update",
                      style: TextStyle(color: Colors.black),
                    ),
                    () {},
                    ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
