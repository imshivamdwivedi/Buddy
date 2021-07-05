import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserIntialInfo extends StatefulWidget {
  const UserIntialInfo({Key? key}) : super(key: key);

  @override
  _UserIntialInfoState createState() => _UserIntialInfoState();
}

class _UserIntialInfoState extends State<UserIntialInfo> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  final _collegeNameController = TextEditingController();
  String _gender = 'Other';
  List list = ['Male', 'Female', 'Other'];

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  value: _gender,
                  onChanged: (newValue) {
                    setState(() {
                      _gender = newValue.toString();
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
                icon: Icons.home,
                text: "College Name",
                val: true,
                controller: _collegeNameController,
              ),
              RoundedButton(
                  size,
                  0.4,
                  Text(
                    "Next",
                    style: TextStyle(color: Colors.black87),
                  ),
                  () => () {},
                  ''),
            ],
          ),
        ),
      ),
    );
  }
}
