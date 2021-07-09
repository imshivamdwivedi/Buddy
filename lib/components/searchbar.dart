import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool val;
  final TextEditingController controller;

  const SearchBar(
      {required this.text,
      required this.val,
      required this.controller,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Color(0xFFD6D5C5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
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
