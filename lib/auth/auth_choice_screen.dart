import 'package:buddy/auth/phone_auth.dart';
import 'package:buddy/auth/sign_in.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/user/screens/user_intial_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthChoiceScreen extends StatefulWidget {
  static const routeName = "/auth-choice";

  @override
  _AuthChoiceScreenState createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  void _saveUserData(String email) async {
    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Users').child(_uid);

    final userModel = new UserModel(
      email: email,
      profile: false,
      id: _uid,
    );

    await _refUser.set(userModel.toMap());
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
        final UserCredential _userCred =
            await _auth.signInWithCredential(credential);
        print('Signed User Up Using Google !');
        //---( Check Here if user Already Exists )---//
        if (_userCred.additionalUserInfo!.isNewUser) {
          _saveUserData(_auth.currentUser!.email.toString());
          Navigator.of(context).pushReplacementNamed(UserIntialInfo.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(UserDashBoard.routeName);
        }
        //return 'signin#done';
      } on FirebaseAuthException catch (_) {
        var msg = 'An error Occured, Please try again!';
        print(msg);
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: msg,
          color: Colors.red,
        );
        //return msg;
        return;
      } catch (e) {
        print(e);
        //return 'signin#error';
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/background.png',
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(15)),
                      onPressed: () {
                        _signinUserByGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Continue with Google",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(15)),
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignIn.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/message.png',
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Continue with Email",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(15)),
                      onPressed: () {
                        Navigator.of(context).pushNamed(PhoneAuth.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/phone.png',
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Continue with Phone No.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
