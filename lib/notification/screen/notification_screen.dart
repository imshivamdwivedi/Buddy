import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/notification/model/notification_provider.dart';
import 'package:buddy/notification/widget/message_notification.dart';
import 'package:buddy/notification/widget/request_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _getNotificationsList();
    super.initState();
  }

  void _getNotificationsList() async {
    final List<NotificationModel> notifications = [];
    final _searchDB = FirebaseDatabase.instance
        .reference()
        .child('Notification')
        .child(_auth.currentUser!.uid);
    await _searchDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final model = NotificationModel.fromMap(element);
          notifications.add(model);
        });
      }
    });
    Provider.of<NotificationProvider>(context, listen: false)
        .setAllNotification(notifications);
  }

  @override
  Widget build(BuildContext context) {
    final notData = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: notData.allNotification[index],
          child: Consumer<NotificationModel>(
            builder: (_, not, child) {
              if (not.type == 'REQ') {
                return RequestNotification(
                  notificationModel: not,
                );
              } else {
                return SimpleNotification('No New Notifications!');
              }
            },
          ),
        ),
        itemCount: notData.allNotification.length,
      ),
    );
  }
}
