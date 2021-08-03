class FollowerModel {
  String name;
  String foid;
  String uid;
  String collegeName;
  String userImg;

  FollowerModel({
    required this.name,
    required this.foid,
    required this.uid,
    required this.userImg,
    required this.collegeName,
  });

  factory FollowerModel.fromMap(Map map) {
    return FollowerModel(
        name: map['name'],
        foid: map['foid'],
        uid: map['uid'],
        userImg: map['userImg'],
        collegeName: map['collegeName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foid': foid,
      'uid': uid,
      'userImg': userImg,
      'collegeName': collegeName
    };
  }
}
