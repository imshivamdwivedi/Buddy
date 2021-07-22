import 'package:flutter/cupertino.dart';

class NotificationModel with ChangeNotifier {
  String id;
  String type;
  String title;
  String nameId;
  String uid;
  String eventId;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.nameId,
    required this.uid,
    required this.eventId,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map map) {
    return NotificationModel(
      id: map['id'],
      type: map['type'],
      title: map['title'],
      nameId: map['nameId'],
      uid: map['uid'],
      eventId: map['eventId'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'nameId': nameId,
        'uid': uid,
        'eventId': eventId,
        'createdAt': createdAt,
      };
}
