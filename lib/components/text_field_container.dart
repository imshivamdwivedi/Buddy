import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double sizeR;

  TextFieldContainer({required this.child, required this.sizeR});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * sizeR,
      decoration: BoxDecoration(
        color: Color(0xFFD6D5C5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
