import 'package:buddy/auth/sign_up.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/sign-in';

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

    if (_email.isEmpty || _pass.isEmpty) {
      //return 'signin#empty';
      print('empty-fields');
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: 'Fields can\' be empty, please provide Credentials!',
        color: Colors.black87,
      );
      return;
    }

    //---( Password Pattern )----//
    if (!validateStructure(_pass)) {
      print('invalid-password-format');
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        title: 'Password should contain:',
        message:
            '\u2022 Minimum 1 Upper case\n\u2022 Minimum 1 Numeric Number\n\u2022 Minimum 1 Special Character',
        color: Colors.black87,
      );
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new CustomLoader().buildLoader(context),
    );

    //---( Password and email Pattern )---//
    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _pass);
      print('Signed User In !');
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
      //return 'signin#done';
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      var msg = 'An error Occured, Please try again!';
      print(msg);
      print(error.code);

      //----( Error Code Output )-----//
      switch (error.code) {
        case 'user-not-found':
          msg = 'User with this email doesn\'t exist!';
          break;
        case 'wrong-password':
          msg = 'Wrong Password, please enter correct password!';
          break;
        case 'invalid-email':
          msg = 'Please provide a valid email!';
          break;
        default:
          msg = 'An error Occured, Please try again!';
      }
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: msg,
        color: Colors.red,
      );
      //return msg;
      return;
    } catch (e) {
      Navigator.of(context).pop();
      print(e);
      CustomSnackbar().showFloatingFlushbar(
          context: context, message: e.toString(), color: Colors.black87);
      //return 'signin#error';
      return;
    }
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
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
              icon: Icons.account_circle,
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
              //() => _signInUser(),
              () => _signInUser(),
              '',
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
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.blue),
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
