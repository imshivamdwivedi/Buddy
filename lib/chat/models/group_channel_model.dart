class GroupChannel {
  String chid;
  String type;
  String users;
  String admins;
  String chName;
  String chImg;
  String createdAt;

  GroupChannel({
    required this.chid,
    required this.type,
    required this.users,
    required this.admins,
    required this.chName,
    required this.chImg,
    required this.createdAt,
  });

  factory GroupChannel.fromMap(Map map) {
    return GroupChannel(
      chid: map['chid'],
      type: map['type'],
      users: map['users'],
      admins: map['admins'],
      chName: map['chName'],
      chImg: map['chImg'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chid': chid,
      'type': type,
      'users': users,
      'admins': admins,
      'chName': chName,
      'chImg': chImg,
      'createdAt': createdAt,
    };
  }
}