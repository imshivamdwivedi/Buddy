import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/user_profile_screen_currentuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateName extends StatefulWidget {
  const UpdateName({Key? key}) : super(key: key);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();

  void _saveUser() async {
    final _firstName = _firstNameController.text.trim().isEmpty
        ? Provider.of<UserProvider>(context).getFirstName()
        : _firstNameController.text.trim();
    final _secondName = _secondNameController.text.trim().isEmpty
        ? Provider.of<UserProvider>(context).getLastName()
        : _secondNameController.text.trim();

    print(_firstName);
    print(_secondName);

    final _user = _auth.currentUser;
    final _refUser =
        _firebaseDatabase.reference().child('Users').child(_user!.uid);

    _refUser.child('firstName').set(_firstName);
    _refUser.child('lastName').set(_secondName);

    Navigator.pushReplacementNamed(context, UserProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: kPrimaryColor,
          title: Text("Update Name", style: TextStyle(color: Colors.black87))),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: Center(
            child: Column(
              children: [
                RoundedInputField(
                    text: Provider.of<UserProvider>(context).getFirstName(),
                    controller: _firstNameController),
                RoundedInputField(
                    text: Provider.of<UserProvider>(context).getLastName(),
                    controller: _secondNameController),
                RoundedButton(
                    size,
                    0.4,
                    Text(
                      "Update",
                      style: TextStyle(color: Colors.black),
                    ),
                    _saveUser,
                    ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
