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
        margin: EdgeInsets.only(top: 4, left: 5, right: 5),
        color: kPrimaryColor,
        child: Column(children: [
          ListTile(
            title: Text(
              msg,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Divider(
            color: Colors.black,
          )
        ]),
      ),
    );
  }
}
