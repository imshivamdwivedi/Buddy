import 'dart:async';

import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  final _notDB = FirebaseDatabase.instance.reference().child('Notification');
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<Event> _notificationStream;

  List<NotificationModel> get allNotifications => _notifications;

  NotificationProvider() {
    _fetchNotifications();
  }

  void _fetchNotifications() {
    _notificationStream =
        _notDB.child(_auth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _notifications.clear();
        notifyListeners();
      } else {
        final _allNotMap = Map<String, dynamic>.from(event.snapshot.value);
        _notifications = _allNotMap.values.map((e) {
          //---( Updating Name and Images )---//
          final notData =
              NotificationModel.fromMap(Map<String, dynamic>.from(e));
          _userDB.child(notData.nameId).once().then((DataSnapshot snapshot) {
            final userModel = UserModel.fromMap(snapshot.value);
            if (userModel.firstName + " " + userModel.lastName !=
                notData.name) {
              _notDB
                  .child(_auth.currentUser!.uid)
                  .child(notData.id)
                  .child('name')
                  .set(userModel.firstName + " " + userModel.lastName);
            }
            if (notData.type == 'REQ' && userModel.userImg != notData.nameImg) {
              _notDB
                  .child(_auth.currentUser!.uid)
                  .child(notData.id)
                  .child('nameImg')
                  .set(userModel.userImg);
            }
          });
          return notData;
        }).toList();
        _notifications.sort((a, b) => a.createdAt > b.createdAt ? -1 : 1);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _notificationStream.cancel();
    super.dispose();
  }
}
