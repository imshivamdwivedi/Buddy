import 'dart:async';

import 'package:buddy/user/models/follower_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FollowerProvider with ChangeNotifier {
  List<FollowerModel> _followers = [];
  final _followerDB = FirebaseDatabase.instance.reference().child('Followers');
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<Event> _followerStream;

  List<FollowerModel> get allFollowers {
    return [..._followers];
  }

  FollowerProvider() {
    _fetchFollowers();
  }

  _fetchFollowers() {
    _followerStream =
        _followerDB.child(_auth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _followers.clear();
        notifyListeners();
      } else {
        final _allFollowersMap =
            Map<String, dynamic>.from(event.snapshot.value);
        _followers = _allFollowersMap.values.map((e) {
          final followerData =
              FollowerModel.fromMap(Map<String, dynamic>.from(e));
          //---( Updating Name and Images )---//
          _userDB.child(followerData.uid).once().then((DataSnapshot snapshot) {
            final userModel = UserModel.fromMap(snapshot.value);
            if (userModel.firstName + " " + userModel.lastName !=
                followerData.name) {
              _followerDB
                  .child(_auth.currentUser!.uid)
                  .child(followerData.foid)
                  .child('name')
                  .set(userModel.firstName + " " + userModel.lastName);
            }
            if (userModel.userImg != followerData.userImg) {
              _followerDB
                  .child(_auth.currentUser!.uid)
                  .child(followerData.foid)
                  .child('userImg')
                  .set(userModel.userImg);
            }
          });
          return followerData;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _followerStream.cancel();
    super.dispose();
  }
}
