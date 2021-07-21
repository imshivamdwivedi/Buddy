import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class AuthChoiceScreen extends StatefulWidget {
  static const routeName = "/auth-choice";

  @override
  _AuthChoiceScreenState createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
      body: Container(
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                    onPressed: () {},
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
    );
  }
}
