import 'package:flutter/material.dart';

import '../components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final IconData icon;
  final String Text;
  final bool val;

  RoundedInputField(
      {this.icon = Icons.person, required this.Text, this.val = false});

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: val,
        cursorColor: Color(0xFF6F35A5),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Color(0xFF6F35A5),
          ),
          hintText: Text,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
