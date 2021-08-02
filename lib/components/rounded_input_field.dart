import 'package:flutter/material.dart';

import '../components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool val;
  final double sizeRatio;
  final TextEditingController controller;
  final TextInputType textInputType;

  RoundedInputField({
    this.icon = Icons.person,
    this.textInputType = TextInputType.emailAddress,
    this.sizeRatio = 0.8,
    required this.text,
    this.val = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        obscureText: val,
        cursorColor: Colors.black,
        autofocus: false,
        decoration: InputDecoration(
          icon: icon != Icons.person
              ? Icon(
                  icon,
                  color: Colors.black,
                )
              : null,
          hintText: text,
          border: InputBorder.none,
        ),
      ),
      sizeR: sizeRatio,
    );
  }
}
