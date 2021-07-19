import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class SimpleNotification extends StatelessWidget {
  final String msg;
  const SimpleNotification(this.msg);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
          color: kPrimaryLightColor,
          child: ListTile(
            title: Text(
              msg,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
