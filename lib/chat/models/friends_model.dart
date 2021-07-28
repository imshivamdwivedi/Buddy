class FriendsModel {
  String fid;
  String uid;
  String name;
  String userImg;

  FriendsModel({
    required this.fid,
    required this.uid,
    required this.name,
    required this.userImg,
  });

  factory FriendsModel.fromMap(Map map) {
    return FriendsModel(
      fid: map['fid'],
      uid: map['uid'],
      name: map['name'],
      userImg: map['userImg'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fid': fid,
      'uid': uid,
      'name': name,
      'userImg': userImg,
    };
  }
}
