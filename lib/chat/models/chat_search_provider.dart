import 'dart:async';

import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatSearchProvider with ChangeNotifier {
  static List<FriendsModel> _friendsList = [];
  final _friendDB = FirebaseDatabase.instance.reference().child('Friends');
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<Event> _friendsStream;

  static List<FriendsModel> get allFriendsList {
    return [..._friendsList];
  }

  List<FriendsModel> get allFriends => [..._friendsList];

  ChatSearchProvider() {
    _fetchFriends();
  }

  void _fetchFriends() {
    _friendsStream =
        _friendDB.child(_auth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _friendsList.clear();
        notifyListeners();
      } else {
        final _allFriendMap = Map<String, dynamic>.from(event.snapshot.value);
        _friendsList = _allFriendMap.values.map((e) {
          //---( Updating Name and Images )---//
          final friendData = FriendsModel.fromMap(Map<String, dynamic>.from(e));
          _userDB.child(friendData.uid).once().then((DataSnapshot snapshot) {
            final userModel = UserModel.fromMap(snapshot.value);
            if (userModel.firstName + " " + userModel.lastName !=
                friendData.name) {
              _friendDB
                  .child(_auth.currentUser!.uid)
                  .child(friendData.fid)
                  .child('name')
                  .set(userModel.firstName + " " + userModel.lastName);
            }
            if (userModel.userImg != friendData.userImg) {
              _friendDB
                  .child(_auth.currentUser!.uid)
                  .child(friendData.fid)
                  .child('userImg')
                  .set(userModel.userImg);
            }
          });
          return friendData;
        }).toList();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _friendsStream.cancel();
    super.dispose();
  }
}

class UserAPI extends ChatSearchProvider {
  static List<FriendsModel> getUserSuggestion(String query) {
    if (query == '') {
      return [];
    }
    List<FriendsModel> lists = ChatSearchProvider.allFriendsList;
    return lists
        .where((friend) => (friend.name)
            .toString()
            .toLowerCase()
            .startsWith(query.toLowerCase()))
        .toList();
  }
}
