class FriendsModel {
  String fid;
  String uid;
  String name;
  String collegeName;
  String userImg;
  bool isFollowing;

  FriendsModel({
    required this.collegeName,
    required this.fid,
    required this.uid,
    required this.name,
    required this.userImg,
    required this.isFollowing,
  });

  factory FriendsModel.fromMap(Map map) {
    return FriendsModel(
      collegeName: map['collegeName'],
      fid: map['fid'],
      uid: map['uid'],
      name: map['name'],
      userImg: map['userImg'],
      isFollowing: map['isFollowing'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collegeName': collegeName,
      'fid': fid,
      'uid': uid,
      'name': name,
      'userImg': userImg,
      'isFollowing': isFollowing,
    };
  }
}
