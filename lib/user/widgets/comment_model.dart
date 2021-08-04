import 'package:flutter/foundation.dart';

class CommentModel {
  final String cid;
  final String uid;
  final String userImg;
  final String userName;
  final String comment;

  CommentModel(
      {required this.cid,
      required this.comment,
      required this.uid,
      required this.userImg,
      required this.userName});

  factory CommentModel.fromMap(Map map) {
    return CommentModel(
      uid: map["uid"],
      cid: map["cid"],
      comment: map["comment"],
      userImg: map["userImg"],
      userName: map["userName"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "cid": cid,
      "comment": comment,
      "userImg": userImg,
      "userName": userName,
    };
  }
}
