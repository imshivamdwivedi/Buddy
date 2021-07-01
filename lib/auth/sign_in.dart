import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Buddy"),
      ),
      body: Column(
        children: [
          RoundedInputField(
            icon: Icons.person,
            Text: "Email",
            val: false,
          ),
          RoundedInputField(
            icon: Icons.lock,
            Text: "Password",
            val: true,
          ),
          RoundedButton(size),
        ],
      ),
    );
  }
}
