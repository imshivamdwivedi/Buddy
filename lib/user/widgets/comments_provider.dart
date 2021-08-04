import 'dart:async';

import 'package:buddy/user/widgets/comment_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CommentProvider with ChangeNotifier {
  List<CommentModel> _comments = [];

  final _commentDB = FirebaseDatabase.instance.reference().child("Comments");
  late StreamSubscription _commentStream;

  List<CommentModel> get allComments {
    return [..._comments];
  }

  void fetchComments(String post_id) {
    _commentStream = _commentDB.child(post_id).onValue.listen((event) {
      if (event.snapshot.value == null) {
        print("Loda-Lahsun");
        _comments.clear();
        notifyListeners();
      } else {
        final allCommentMap = Map<String, dynamic>.from(event.snapshot.value);

        _comments = allCommentMap.values.map((e) {
          final tempCommentModel = CommentModel.fromMap(e);

          return tempCommentModel;
        }).toList();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _commentStream.cancel();
    super.dispose();
  }
}
