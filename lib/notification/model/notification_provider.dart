import 'dart:async';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  final _notDB = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<Event> _notificationStream;

  List<NotificationModel> get allNotifications => _notifications;

  NotificationProvider() {
    _fetchNotifications();
  }

  void _fetchNotifications() {
    _notificationStream = _notDB
        .child('Notification')
        .child(_auth.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value == null) {
        _notifications.clear();
        notifyListeners();
      } else {
        final DataSnapshot snap = event.snapshot;
        final _allNotMap = Map<String, dynamic>.from(event.snapshot.value);
        _notifications = _allNotMap.values
            .map((e) => NotificationModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
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
