import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/forget-password';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();

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
              icon: Icons.account_circle,
              text: "Email ",
              val: false,
              controller: _emailController,
            ),
            RoundedButton(
              size,
              0.4,
              Text(
                "Next",
                style: TextStyle(color: Colors.black87),
              ),
              () => {},
              '',
            ),
          ],
        ),
      ),
    );
  }
}
