import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class UserNotificationItem extends StatelessWidget {
  final String msg;
  const UserNotificationItem(this.msg);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: kPrimaryLightColor,
        child: ListTile(
          title: Text(
            msg,
            style: TextStyle(color: Colors.black87),
          ),
          trailing: IconButton(
            onPressed: () => () {},
            icon: Icon(
              Icons.close_rounded,
            ),
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  toList() {}
}
