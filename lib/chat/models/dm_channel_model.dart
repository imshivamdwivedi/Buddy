class DmChannel {
  String chid;
  String type;
  String users;

  DmChannel({
    required this.chid,
    required this.type,
    required this.users,
  });

  factory DmChannel.fromMap(Map map) {
    return DmChannel(
      chid: map['chid'],
      type: map['type'],
      users: map['users'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chid': chid,
      'type': type,
      'users': users,
    };
  }
}
