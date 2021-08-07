import 'dart:async';

import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeSearchProvider with ChangeNotifier {
  List<HomeSearchHelper> allUsersList = [];
  List<HomeSearchHelper> filteredList = [];
  List<String> tags = [];
  final _auth = FirebaseAuth.instance;
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  late StreamSubscription<Event> _userListStream;

  List<ActivityModel> allEventsList = [];
  List<ActivityModel> filteredEventsList = [];
  final _eventDB = FirebaseDatabase.instance.reference().child('Activity');
  late StreamSubscription<Event> _eventListStream;

  List<GroupChannel> allCommunity = [];
  List<GroupChannel> filteredCommunity = [];
  final _communityDB = FirebaseDatabase.instance.reference().child('Chats');
  late StreamSubscription<Event> _communityStream;

  List<HomeSearchHelper> get suggestedUsers {
    return [...filteredList];
  }

  List<ActivityModel> get suggestedEvents {
    return [...filteredEventsList];
  }

  List<GroupChannel> get suggestedCommunity {
    return [...filteredCommunity];
  }

  List<ActivityModel> get allEvents {
    return [...allEventsList];
  }

  List<String> get allTags {
    return [...tags];
  }

  HomeSearchProvider() {
    _fetchUserList();
    _fetchEventList();
    _fetchCommunity();
  }

  void refresh() {
    filteredCommunity.clear();
    tags.clear();
    filteredEventsList.clear();
    filteredList.clear();
    _fetchUserList();
    _fetchEventList();
    _fetchCommunity();
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

  void _fetchEventList() {
    _eventListStream = _eventDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        allEventsList.clear();
        notifyListeners();
      } else {
        final _allEventMap = Map<String, dynamic>.from(event.snapshot.value);
        allEventsList = _allEventMap.values.map((e) {
          final actModel = ActivityModel.fromMap(Map<String, dynamic>.from(e));
          return actModel;
        }).toList();
        notifyListeners();
      }
    });
  }

  void _fetchCommunity() {
    _communityStream = _communityDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        allCommunity.clear();
        notifyListeners();
      } else {
        final _allCommnityMap = Map<String, dynamic>.from(event.snapshot.value);
        allCommunity = _allCommnityMap.values.map((e) {
          final comModel = GroupChannel.fromMap(Map<String, dynamic>.from(e));
          return comModel;
        }).toList();
        notifyListeners();
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
      filteredEventsList.clear();
      filteredCommunity.clear();
      notifyListeners();
      tags = [];
      return;
    }

    tags.clear();
    filteredList = allUsersList;
    filteredEventsList = allEventsList;
    filteredCommunity = allCommunity;

    final filters = query.trim().split(' ');
    tags = filters;

    filters.forEach((filter) {
      final newFilter = filteredList
          .where((element) => element.userModel.searchTag
              .toLowerCase()
              .contains(filter.toLowerCase()))
          .toList();
      filteredList = newFilter;

      final newEventFilter = filteredEventsList
          .where((element) => element.title
              .trim()
              .toLowerCase()
              .replaceAll(' ', '')
              .contains(filter.toLowerCase()))
          .toList();
      filteredEventsList = newEventFilter;

      final newCommunityFilter = filteredCommunity
          .where((element) => element.chName
              .trim()
              .toLowerCase()
              .replaceAll(' ', '')
              .contains(filter.toLowerCase()))
          .toList();
      filteredCommunity = newCommunityFilter;
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _userListStream.cancel();
    _eventListStream.cancel();
    _communityStream.cancel();
    super.dispose();
  }
}

//---( Here Model Class )---//
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
