import 'dart:async';

import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeSearchProvider with ChangeNotifier {
  List<HomeSearchHelper> allUsersList = [];
  List<HomeSearchHelper> filteredList = [];
  final _auth = FirebaseAuth.instance;
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  late StreamSubscription<Event> _userListStream;

  List<ActivityModel> allEvents = [];
  List<ActivityModel> filteredEvents = [];
  List<String> tags = [];

  List<HomeSearchHelper> get suggestedUsers {
    return [...filteredList];
  }

  List<ActivityModel> get suggestedEvents {
    return [...filteredEvents];
  }

  List<String> get allTags {
    return [...tags];
  }

  HomeSearchProvider() {
    _fetchUserList();
  }

  void refresh() {
    _fetchUserList();
  }

  void _fetchUserList() {
    _userListStream = _userDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        allUsersList.clear();
        notifyListeners();
      } else {
        final _allUserListMap = Map<String, dynamic>.from(event.snapshot.value);
        _preFilterUsers(_allUserListMap);
      }
    });
  }

  void _preFilterUsers(Map<String, dynamic> map) async {
    final _user = _auth.currentUser;
    final List<String> friendsId = [];
    final List<String> requestsId = [];
    final _friendsDB = FirebaseDatabase.instance
        .reference()
        .child('Friends')
        .child(_user!.uid);
    await _friendsDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          friendsId.add(element['uid']);
        });
      }
    });
    final _requestDB = FirebaseDatabase.instance
        .reference()
        .child('Requests')
        .child(_user.uid);
    await _requestDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          requestsId.add(element['uid']);
        });
      }
    });
    allUsersList = map.values.map((e) {
      final userM = UserModel.fromMap(Map<String, dynamic>.from(e));
      final homeU = HomeSearchHelper(
        userModel: userM,
        isPending: requestsId.contains(userM.id),
        isFriend: friendsId.contains(userM.id),
      );
      return homeU;
    }).toList();
    final _element = allUsersList.firstWhere(
        (element) => element.userModel.id == _auth.currentUser!.uid);
    allUsersList.remove(_element);
    notifyListeners();
  }

  void updateQuery(String query) {
    if (query == '') {
      filteredList.clear();
      notifyListeners();
      tags = [];
      return;
    }

    tags.clear();
    filteredList = allUsersList;

    final filters = query.trim().split(' ');
    tags = filters;

    filters.forEach((filter) {
      final newFilter = filteredList
          .where((element) => element.userModel.searchTag.contains(filter))
          .toList();
      filteredList = newFilter;
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _userListStream.cancel();
    super.dispose();
  }
}

//H://---( Here Model Class )---//
class HomeSearchHelper with ChangeNotifier {
  UserModel userModel;
  bool isPending;
  bool isFriend;

  HomeSearchHelper({
    required this.userModel,
    this.isPending = false,
    this.isFriend = false,
  });

  void toggleFriend() {
    isPending = true;
    notifyListeners();
  }
}
