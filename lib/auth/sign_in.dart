// import 'package:buddy/auth/forget-password.dart';
import 'package:buddy/auth/sign_up.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign In ",
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
            RoundedInputField(
              icon: Icons.phone,
              text: "Password",
              val: true,
            ),
            RoundedButton(
                size,
                0.4,
                Text(
                  "Next",
                  style: TextStyle(color: Colors.black87),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New User ?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUp.routeName);
                    },
                    child: Text("Sign up !",
                        style: TextStyle(fontWeight: FontWeight.w500))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
