import 'package:flutter/material.dart';

import '../auth/sign_in.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../components/social_icons.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/sign-up';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up ",
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
                  "Already Exist ?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignIn.routeName);
                    },
                    child: Text("Sign in !")),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                ),
                SocalIcon(iconSrc: "assets/icons/twitter.svg"),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
