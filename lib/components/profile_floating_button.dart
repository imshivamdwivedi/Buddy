import 'package:flutter/material.dart';

class ProfileFloatingButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double height;
  final double width;

  ProfileFloatingButton(
      {required this.color,
      required this.icon,
      this.iconColor = Colors.black,
      this.height = 40.0,
      this.width = 40.0,
      this.iconSize = 20.0});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 5.0,
      shape: CircleBorder(),
      fillColor: color,
      onPressed: () {},
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
      constraints: BoxConstraints.tightFor(
        width: height,
        height: width,
      ),
    );
  }
}
