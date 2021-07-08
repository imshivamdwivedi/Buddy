import 'package:flutter/material.dart';

import '../components/text_field_container.dart';

class TextArea extends StatelessWidget {
  final String text;
  final bool val;
  final TextEditingController controller;

  TextArea({
    required this.text,
    this.val = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Color(0xFFD6D5C5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: val,
        cursorColor: Colors.black,
        minLines:
            6, // any number you need (It works as the rows for the textarea)
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
