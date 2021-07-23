import 'package:flutter/material.dart';

import '../components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool val;
  final double sizeRatio;
  final TextEditingController controller;

  RoundedInputField({
    this.icon = Icons.person,
    this.sizeRatio = 0.8,
    required this.text,
    this.val = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        obscureText: val,
        cursorColor: Colors.black,
        autofocus: false,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: text,
          border: InputBorder.none,
        ),
      ),
      sizeR: sizeRatio,
    );
  }
}
