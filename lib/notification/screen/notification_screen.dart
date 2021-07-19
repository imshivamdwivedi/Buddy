import 'package:buddy/constants.dart';
import 'package:buddy/notification/widget/event_notification.dart';
import 'package:buddy/notification/widget/message_notification.dart';
import 'package:buddy/notification/widget/request_notification.dart';
import 'package:flutter/material.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  List<SimpleNotification> userNotificationsList = [
    SimpleNotification(
      "Aditi just followed you !",
    ),
    SimpleNotification("You have signed Up. Rate our App !"),
  ];
  final tab = new TabBar(tabs: <Tab>[
    new Tab(icon: new Icon(Icons.arrow_forward)),
    new Tab(icon: new Icon(Icons.arrow_downward)),
    new Tab(icon: new Icon(Icons.arrow_back)),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: ListView(
          //     children: userNotificationsList.map((tx) => tx).toList(),
          //   ),
          // ),
          SimpleNotification(
              "cdbjdvchgvdchgvdhgcvdhgcvhgdcvhgdvchgdvchgvdhcgvdhcvdhgcvhgdvchg"),
          RequestNotification(),
          EventNotification()
        ],
      ),
    );
  }
}
