import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/notification_provider.dart';
import 'package:buddy/notification/widget/message_notification.dart';
import 'package:buddy/notification/widget/request_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, value, child) {
          if (value.allNotifications.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EventCard(),
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
          } else {
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                  child: ListView.builder(
                    itemCount: value.allNotifications.length,
                    itemBuilder: (ctx, index) {
                      final notification = value.allNotifications[index];
                      if (notification.type == 'REQT') {
                        return SimpleNotification(notification.title
                            .replaceAll('#NAME', notification.name));
                      } else if (notification.type == 'REQ') {
                        return RequestNotification(
                            notificationModel: notification);
                      } else {
                        return SimpleNotification(notification.title);
                      }
                    },
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
