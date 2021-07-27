class FriendsModel {
  String fid;
  String uid;
  String name;
  String userImg;

  FriendsModel({
    required this.fid,
    required this.uid,
    this.name = '',
    this.userImg = '',
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
