import 'package:flutter/material.dart';

class ProfileFloatingButton extends StatelessWidget {
  final Color color;
  final IconData icon;

  ProfileFloatingButton({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 2.0,
      shape: CircleBorder(),
      fillColor: color,
      onPressed: () {},
      child: Icon(
        icon,
        color: Colors.black87,
        size: 20.0,
      ),
      constraints: BoxConstraints.tightFor(
        width: 40.0,
        height: 40.0,
      ),
    );
  }
}
