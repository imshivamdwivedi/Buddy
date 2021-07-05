import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedButton extends StatelessWidget {
  final Size size;
  final double sizeRatio;
  final Widget text;
  final Function _onPressed;
  final String icon;

  RoundedButton(
      this.size, this.sizeRatio, this.text, this._onPressed, this.icon);

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
          onPressed: () {
            _onPressed();
          },
          child: (icon.isEmpty)
              ? text
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      icon,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    text,
                  ],
                ),
        ),
      ),
    );
  }
}
