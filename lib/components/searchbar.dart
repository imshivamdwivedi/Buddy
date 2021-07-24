import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool val;

  const SearchBar(
      {required this.text, this.icon = Icons.ac_unit, required this.val});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.07,
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.01,
      ),
      width: size.width * 0.75,
      decoration: BoxDecoration(
        color: Color(0xFFD6D5C5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(blurRadius: 5, color: Colors.grey, spreadRadius: 2)
        ],
      ),
      child: TextField(
        enabled: val,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          icon: icon == Icons.ac_unit
              ? null
              : Icon(
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
