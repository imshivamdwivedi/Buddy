import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:buddy/onboarder/onboarder_widget.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserIntialInfo extends StatefulWidget {
  static const routeName = 'user-info';
  @override
  _UserIntialInfoState createState() => _UserIntialInfoState();
}

class _UserIntialInfoState extends State<UserIntialInfo> {
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  String _genderName = 'Select gender';
  List list = ['Select gender', 'Male', 'Female', 'Other'];
  final _collegeController = TextEditingController();

  void _birthDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1970),
            lastDate: DateTime(2011))
        .then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        _selectedDate = datePicked;
      });
    });
  }

  Widget dateButton(Size size, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.575,
      decoration: BoxDecoration(
        color: Color(0xFFD6D5C5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        obscureText: false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.black87,
          ),
          hintText: text,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _saveUserData(BuildContext context) async {
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _dob = _selectedDate.toString();
    final _gender = _genderName;
    final _college = _collegeController.text.trim();

    //----( Validation )---------//
    if (_firstName.isEmpty ||
        _lastName.isEmpty ||
        _gender.isEmpty ||
        _college.isEmpty) {
      print('empty-fileds');
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: 'Fields can\'t be empty, please fill all details ! :(',
        color: Colors.black87,
      );
      return;
    }

    //---( Saving to firebase )-----//
    final _user = _auth.currentUser;
    final _refUser =
        _firebaseDatabase.reference().child('Users').child(_user!.uid);
    final userModel = new UserModel(
      firstName: _firstName,
      lastName: _lastName,
      dob: _dob,
      gender: _gender,
      email: _user.email.toString(),
      collegeName: _college,
      profile: true,
      id: _user.uid,
    );
    await _refUser.set(userModel.toMap());

    Navigator.pushReplacementNamed(context, OnboarderWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              RoundedInputField(
                icon: Icons.person,
                text: "First Name ",
                val: false,
                controller: _firstNameController,
              ),
              RoundedInputField(
                icon: Icons.person,
                text: "Second Name",
                val: false,
                controller: _lastNameController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dateButton(
                      size,
                      (_selectedDate == DateTime.now()
                          ? "Enter D.O.B - dd/mm/yyyy"
                          : "${DateFormat.yMd().format(_selectedDate)}")),
                  SocalIcon(
                      iconSrc: "assets/icons/calender.svg",
                      onPressed: _birthDatePicker),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Color(0xFFD6D5C5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: new DropdownButton(
                  hint: Text("Gender"),
                  isExpanded: true,
                  value: _genderName,
                  onChanged: (newValue) {
                    setState(() {
                      _genderName = newValue.toString();
                    });
                  },
                  items: list.map((valueItem) {
                    // print(valueItem);
                    return new DropdownMenuItem(
                        child: Text(valueItem), value: valueItem);
                  }).toList(),
                ),
              ),
              RoundedInputField(
                icon: Icons.school,
                text: "College",
                val: false,
                controller: _collegeController,
              ),
              RoundedButton(
                  size,
                  0.4,
                  Text(
                    "Next",
                    style: TextStyle(color: Colors.black87),
                  ),
                  () => _saveUserData(context),
                  ''),
            ],
          ),
        ),
      ),
    );
  }
}
