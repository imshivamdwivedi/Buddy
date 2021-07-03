// import 'package:buddy/auth/forget-password.dart';
import 'package:buddy/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signInUser() async {
    final _email = _emailController.text.trim();
    final _pass = _passwordController.text.trim();

    print(_email);
    print(_pass);

    if (_email.isEmpty && _pass.isEmpty) {
      //return 'signin#empty';
      print('empty-fields');
      return;
    }
    //---( Password and email Pattern )---//
    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _pass);
      print('Signed User In !');
      //return 'signin#done';
    } on PlatformException catch (error) {
      var msg = 'An error Occured, Please check your Credentials!';
      if (error.message != null) {
        msg = error.message.toString();
      }
      print(msg);
      //return msg;
      return;
    } catch (e) {
      print(e);
      //return 'signin#error';
      return;
    }
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
              controller: _emailController,
            ),
            RoundedInputField(
              icon: Icons.lock,
              text: "Password",
              val: true,
              controller: _passwordController,
            ),
            RoundedButton(
              size,
              0.4,
              Text(
                "Next",
                style: TextStyle(color: Colors.black87),
              ),
              () => _signInUser(),
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
                    Navigator.of(context)
                        .pushReplacementNamed(SignUp.routeName);
                  },
                  child: Text(
                    "Sign up !",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
