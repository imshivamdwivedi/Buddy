import 'dart:async';

import 'package:buddy/user/models/follower_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FollowingProvider with ChangeNotifier {
  List<FollowerModel> _followings = [];
  List<String> _userIds = [];
  final _followingDB = FirebaseDatabase.instance.reference().child('Following');
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<Event> _followingStream;

  List<FollowerModel> get allFollowings {
    return [..._followings];
  }

  List<String> get followingsUid {
    return [..._userIds];
  }

  FollowingProvider() {
    _fetchFollowings();
  }

  _fetchFollowings() {
    _followingStream =
        _followingDB.child(_auth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _followings.clear();
        _userIds.clear();
        notifyListeners();
      } else {
        _userIds.clear();
        final _allFollowingsMap =
            Map<String, dynamic>.from(event.snapshot.value);
        _followings = _allFollowingsMap.values.map((e) {
          final followingData =
              FollowerModel.fromMap(Map<String, dynamic>.from(e));
          //---( Updating Name and Images )---//
          _userDB.child(followingData.uid).once().then((DataSnapshot snapshot) {
            final userModel = UserModel.fromMap(snapshot.value);
            if (userModel.firstName + " " + userModel.lastName !=
                followingData.name) {
              _followingDB
                  .child(_auth.currentUser!.uid)
                  .child(followingData.foid)
                  .child('name')
                  .set(userModel.firstName + " " + userModel.lastName);
            }
            if (userModel.userImg != followingData.userImg) {
              _followingDB
                  .child(_auth.currentUser!.uid)
                  .child(followingData.foid)
                  .child('userImg')
                  .set(userModel.userImg);
            }
          });
          _userIds.add(followingData.uid);
          return followingData;
        }).toList();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _followingStream.cancel();
    super.dispose();
  }
}
