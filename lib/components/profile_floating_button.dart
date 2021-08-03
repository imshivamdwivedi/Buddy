import 'package:flutter/material.dart';

class ProfileFloatingButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  ProfileFloatingButton(
      {required this.color, required this.icon, this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 2.0,
      shape: CircleBorder(),
      fillColor: color,
      onPressed: () {},
      child: Icon(
        icon,
        color: iconColor,
        size: 20.0,
      ),
      constraints: BoxConstraints.tightFor(
        width: 40.0,
        height: 40.0,
      ),
    );
  }
}
