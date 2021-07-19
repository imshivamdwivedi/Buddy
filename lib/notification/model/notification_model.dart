import 'package:flutter/cupertino.dart';

class NotificationModel with ChangeNotifier {
  String id;
  String type;
  String title;
  String name;
  String nameId;
  String uid;
  String eventName;
  String eventId;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.name,
    required this.nameId,
    required this.uid,
    required this.eventName,
    required this.eventId,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map map) {
    return NotificationModel(
      id: map['id'],
      type: map['type'],
      title: map['title'],
      name: map['name'],
      nameId: map['nameId'],
      uid: map['uid'],
      eventName: map['eventName'],
      eventId: map['eventId'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'name': name,
        'nameId': nameId,
        'uid': uid,
        'eventName': eventName,
        'eventId': eventId,
        'createdAt': createdAt,
      };
}
