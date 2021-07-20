class DmChannel {
  String chid;
  String fUserId;
  String fUserName;
  String sUserId;
  String sUserName;
  String type;
  String users;

  DmChannel({
    required this.chid,
    required this.fUserId,
    required this.fUserName,
    required this.sUserId,
    required this.sUserName,
    required this.type,
    required this.users,
  });

  factory DmChannel.fromMap(Map map) {
    return DmChannel(
      chid: map['chid'],
      fUserId: map['fUserId'],
      fUserName: map['fUserName'],
      sUserId: map['sUserId'],
      sUserName: map['sUserName'],
      type: map['type'],
      users: map['users'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chid': chid,
      'fUserId': fUserId,
      'fUserName': fUserName,
      'sUserId': sUserId,
      'sUserName': sUserName,
      'type': type,
      'users': users,
    };
  }
}
