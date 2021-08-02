import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
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
  final _numberController = TextEditingController();
  final _codeController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn = false;
  bool sendOtp = false;
  late String uid;
  late String _verificationId;
  late String code;

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    code = countryCode.toString();
    print(code);
  }

  void _verifyOTP() async {
    final credential = await PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _codeController.text);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _sentOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: code + " " + _numberController.text,
        verificationCompleted: verificationCompleted,
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
      isLoggedIn = false;
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

  void verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLoggedIn = true;
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
    } else {
      print("Failed to sign in");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoggedIn
          ? Container(
              child: Center(
                child: Text("Logged In"),
              ),
            )
          : Container(
              child: sendOtp
                  ? Column(
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
