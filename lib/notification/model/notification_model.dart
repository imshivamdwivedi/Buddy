class NotificationModel {
  String id;
  String type;
  String title;
  String name;
  String nameId;
  String uid;
  String eventId;
  int createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.name,
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
      name: map['name'],
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
        'name': name,
        'nameId': nameId,
        'uid': uid,
        'eventId': eventId,
        'createdAt': createdAt,
      };
}
