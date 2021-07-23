import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/notification/model/notification_provider.dart';
import 'package:buddy/notification/widget/message_notification.dart';
import 'package:buddy/notification/widget/request_notification.dart';
import 'package:buddy/user/models/user_model.dart';
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
  bool init = true;

  @override
  void initState() {
    super.initState();
    _getNotificationsList(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      init = false;
      _getNotificationsList(context);
    }
  }

  void _getNotificationsList(BuildContext ctx) async {
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
          if (model.type == 'REQT') {
            final _dbRef = FirebaseDatabase.instance.reference().child('Users');
            _dbRef
                .orderByChild('id')
                .equalTo(model.nameId)
                .once()
                .then((value) {
              Map map = value.value;
              map.values.forEach((element) {
                final user = UserModel.fromMap(element);
                final title = model.title.replaceAll(
                    '#NAME', (user.firstName + " " + user.lastName));
                model.title = title;
              });
            });
            notifications.add(model);
          } else if (model.type == 'REQ') {
            final _dbRef = FirebaseDatabase.instance.reference().child('Users');
            _dbRef
                .orderByChild('id')
                .equalTo(model.nameId)
                .once()
                .then((value) {
              Map map = value.value;
              map.values.forEach((element) {
                final user = UserModel.fromMap(element);
                final title = (user.firstName + " " + user.lastName);
                model.title = title;
              });
            });
            notifications.add(model);
          }
        });
      }
    });
    Provider.of<NotificationProvider>(ctx, listen: false)
        .setAllNotification(notifications);
  }

  @override
  Widget build(BuildContext context) {
    final allNotifications =
        Provider.of<NotificationProvider>(context).allNotification;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: allNotifications.isEmpty
          ? Column(
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
            )
          : ListView.builder(
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: allNotifications[index],
                child: Consumer<NotificationModel>(
                  builder: (_, not, child) {
                    if (not.type == 'REQ') {
                      return RequestNotification(
                        notificationModel: not,
                      );
                    } else if (not.type == 'TEXT') {
                      return SimpleNotification(not.title);
                    } else if (not.type == 'REQT') {
                      return SimpleNotification(not.title);
                    } else {
                      return SimpleNotification('No New Notifications!');
                    }
                  },
                ),
              ),
              itemCount: allNotifications.length,
            ),
    );
  }
}
