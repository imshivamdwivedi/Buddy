class FriendsModel {
  String fid;
  String uid;
  String name;

  FriendsModel({
    required this.fid,
    required this.uid,
    this.name = '',
  });

  factory FriendsModel.fromMap(Map map) {
    return FriendsModel(
      fid: map['fid'],
      uid: map['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fid': fid,
      'uid': uid,
    };
  }
}
