class FriendsModel {
  String fid;
  String uid;
  String name;

  FriendsModel({
    required this.fid,
    required this.uid,
    required this.name,
  });

  factory FriendsModel.fromMap(Map map) {
    return FriendsModel(
      fid: map['fid'],
      uid: map['uid'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fid': fid,
      'uid': uid,
      'name': name,
    };
  }
}
