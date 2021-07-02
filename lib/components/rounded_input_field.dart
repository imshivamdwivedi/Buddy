import 'package:flutter/material.dart';

import '../components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool val;

  RoundedInputField(
      {this.icon = Icons.person, required this.text, this.val = false});

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: val,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: text,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
