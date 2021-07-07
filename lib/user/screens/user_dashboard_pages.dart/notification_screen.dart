import 'package:buddy/constants.dart';
import 'package:buddy/user/widgets/user_notification_item.dart';
import 'package:flutter/material.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  List<UserNotificationItem> userNotificationsList = [
    UserNotificationItem(
      "Aditi just followed you !",
    ),
    UserNotificationItem("Parneet is interested in yor event"),
    UserNotificationItem("You have signed Up. Rate our App !"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: userNotificationsList.map((tx) => tx).toList(),
      ),
    );
  }
}
