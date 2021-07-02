import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/forget-password';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forget Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedInputField(
              icon: Icons.person,
              text: "Email ",
              val: false,
            ),
            RoundedButton(size, "Next"),
          ],
        ),
      ),
    );
  }
}
