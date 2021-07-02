import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Size size;
  final double sizeRatio;
  final Widget text;

  RoundedButton(this.size, this.sizeRatio, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      width: size.width * sizeRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0XFFF1F0E8),
            shadowColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          ),
          onPressed: () {},
          child: text,
        ),
      ),
    );
  }
}
