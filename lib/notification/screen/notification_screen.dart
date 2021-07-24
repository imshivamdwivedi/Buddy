import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/notification/widget/message_notification.dart';
import 'package:buddy/notification/widget/request_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  DatabaseReference _notifications = FirebaseDatabase.instance
      .reference()
      .child('Notification')
      .child(FirebaseAuth.instance.currentUser!.uid);

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
      body: StreamBuilder<Event>(
        stream: _notifications.onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data!.snapshot.value != null) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: FirebaseAnimatedList(
                sort: (a, b) {
                  return a.value['createdAt'] > b.value['createdAt'] ? -1 : 1;
                },
                query: _notifications,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final notification =
                      NotificationModel.fromMap(snapshot.value);
                  if (notification.type == 'REQT') {
                    return SimpleNotification(notification.title
                        .replaceAll('#NAME', notification.name));
                  } else if (notification.type == 'REQ') {
                    return RequestNotification(notificationModel: notification);
                  } else {
                    return SimpleNotification(notification.title);
                  }
                },
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/nonewnot.png",
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'No New Notifications!',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
