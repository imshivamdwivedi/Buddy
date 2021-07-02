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
              icon: Icons.phone,
              text: "Phone no.",
              val: false,
            ),
            RoundedButton(size, "Next"),
            SizedBox(
              height: 5,
            ),
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
                    child: Text("Sign up !")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
