import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/user/screens/user_intial_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneAuth extends StatefulWidget {
  static const routeName = "/phone-auth";
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _auth = FirebaseAuth.instance;
  final _numberController = TextEditingController();
  final _codeController = TextEditingController();

  bool sendOtp = false;
  late String _verificationId;
  late String code;

  void _onCountryChange(CountryCode countryCode) {
    code = countryCode.toString();
    print(code);
  }

  void _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _codeController.text);
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        Navigator.pushReplacementNamed(context, UserIntialInfo.routeName);
      } else {
        Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
      }
    } catch (e) {
      print(e);
    }
  }

  void _sentOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: code + " " + _numberController.text,
        verificationCompleted: (_) {},
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

    setState(() {
      sendOtp = true;
    });
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception);
    setState(() {
      sendOtp = false;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _verificationId = verificationId;
      sendOtp = true;
    });
  }

  void codeSent(String verificationId, [int? code]) async {
    setState(() {
      _verificationId = verificationId;
      sendOtp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: sendOtp
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedInputField(
                    controller: _codeController,
                    text: 'Enter OTP',
                    textInputType: TextInputType.number,
                  ),
                  RoundedButton(
                    size,
                    0.4,
                    Text(
                      "Verify OTP",
                      style: TextStyle(color: Colors.black87),
                    ),
                    //() => _signInUser(),
                    () => _verifyOTP(),
                    '',
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        child: CountryCodePicker(
                          onChanged: _onCountryChange,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'USA',
                          favorite: ['+91', 'IND'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ),
                      Container(
                        child: RoundedInputField(
                          controller: _numberController,
                          text: 'Enter phone no.',
                          textInputType: TextInputType.number,
                          sizeRatio: 0.7,
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: RoundedButton(
                      size,
                      0.4,
                      Text(
                        "Next",
                        style: TextStyle(color: Colors.black87),
                      ),
                      //() => _signInUser(),
                      () => _sentOTP(),
                      '',
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
