import 'package:buddy/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }

  void _createUser() async {
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
      await _auth.createUserWithEmailAndPassword(
          email: _email, password: _pass);
      print('Signed User Up !');
      _saveUserData(_email);
      Navigator.of(context).pushReplacementNamed(SignIn.routeName);
      //return 'signin#done';
    } on PlatformException catch (error) {
      var msg = 'An error Occured, Please check your Connection!';
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

  void _saveUserData(String email) {
    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Users').child(_uid);

    UserModel userModel = new UserModel(
      name: 'Parneet',
      email: email,
      phoneNumber: '8586825947',
    );

    _refUser.set(userModel.toJson());

    /*_refUser.child('userEmail').set(email);
    _refUser.child('userId').set(_uid);*/
  }

  void _signinUserByGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        await _auth.signInWithCredential(credential);
        print('Signed User Up Using Google !');
        _saveUserData(_auth.currentUser!.email.toString());
        Navigator.of(context).pushReplacementNamed(SignIn.routeName);
        //return 'signin#done';
      } on FirebaseAuthException catch (error) {
        var msg = 'An error Occured, Please check your Connection!';
        if (error.message != null) {
          msg = error.message.toString();
        }
        print('ERROR ------------- ');
        print(msg);
        //return msg;
        return;
      } catch (e) {
        print(e);
        //return 'signin#error';
        return;
      }
    }
  }

  /*void _signinUserByFacebook() async {
    print('facebook login reached');
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn();

    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    try {
      await _auth.signInWithCredential(facebookAuthCredential);
      print('Signed User Up Using Facebook !');
      _saveUserData(_auth.currentUser!.email.toString());
      Navigator.of(context).pushReplacementNamed(SignIn.routeName);
      //return 'signin#done';
    } on FirebaseAuthException catch (error) {
      var msg = 'An error Occured, Please check your Connection!';
      if (error.message != null) {
        msg = error.message.toString();
      }
      print('ERROR ------------- ');
      print(msg);
      //return msg;
      return;
    } catch (e) {
      print(e);
      //return 'signin#error';
      return;
    }
  }*/

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
              icon: Icons.person,
              text: "Email ",
              val: false,
              controller: _emailController,
            ),
            SizedBox(
              height: 5,
            ),
            RoundedInputField(
              icon: Icons.lock,
              text: "Password",
              val: true,
              controller: _passwordController,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Or",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButton(
                  size,
                  0.7,
                  Text(
                    'Signin with Google',
                    style: TextStyle(color: Colors.black87),
                  ),
                  () {},
                  'assets/icons/googlesignin.svg',
                ),
              ],
            ),
            RoundedButton(
              size,
              0.4,
              Text(
                'Next ',
                style: TextStyle(color: Colors.black87),
              ),
              () => _createUser(),
              '',
            ),
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
                      Navigator.of(context)
                          .pushReplacementNamed(SignIn.routeName);
                    },
                    child: Text("Sign in !")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
