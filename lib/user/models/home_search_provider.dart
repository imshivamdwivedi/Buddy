import 'dart:async';

import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/follower_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeSearchProvider with ChangeNotifier {
  List<String> allCommunities = [];
  List<String> allFollowings = [];
  List<String> allFriends = [];
  final auth = FirebaseAuth.instance;

  List<HomeSearchHelper> allUsersList = [];
  List<HomeSearchHelper> filteredList = [];
  List<String> tags = [];
  final _auth = FirebaseAuth.instance;
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  late StreamSubscription<Event> _userListStream;

  List<ActivityModel> allEventsVisibleList = [];
  List<ActivityModel> allEventsSearchList = [];
  List<ActivityModel> allPublicEventList = [];
  List<ActivityModel> allFollowingEventList = [];
  List<ActivityModel> allCommunityEventList = [];
  List<ActivityModel> allConnectionEventList = [];
  List<ActivityModel> filteredEventsList = [];
  final _eventDB = FirebaseDatabase.instance.reference().child('Activity');
  late StreamSubscription<Event> _eventListStream;

  List<CommunitySearchHelper> allCommunity = [];
  List<CommunitySearchHelper> filteredCommunity = [];
  final _communityDB = FirebaseDatabase.instance.reference().child('Chats');
  late StreamSubscription<Event> _communityStream;

  List<HomeSearchHelper> get suggestedUsers {
    return [...filteredList];
  }

  List<ActivityModel> get suggestedEvents {
    return [...filteredEventsList];
  }

  List<CommunitySearchHelper> get suggestedCommunity {
    return [...filteredCommunity];
  }

  List<ActivityModel> get allVisibleEvent {
    return [...allEventsVisibleList];
  }

  List<String> get allTags {
    return [...tags];
  }

  void refresh() {
    filteredCommunity.clear();
    tags.clear();
    filteredEventsList.clear();
    filteredList.clear();
    _fetchCurrentCommunities();
    _fetchCurrentFollowing();
    _fetchUserList();
    _fetchEventList();
    _fetchCommunity();
    _fetchCurrentFriendsList();
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
        allPublicEventList.clear();
        allCommunityEventList.clear();
        allConnectionEventList.clear();
        allFollowingEventList.clear();
        allEventsVisibleList.clear();
        allEventsSearchList.clear();
        notifyListeners();
      } else {
        allPublicEventList.clear();
        allCommunityEventList.clear();
        allConnectionEventList.clear();
        allFollowingEventList.clear();
        allEventsVisibleList.clear();
        allEventsSearchList.clear();
        final _allEventMap = Map<String, dynamic>.from(event.snapshot.value);
        _allEventMap.values.forEach((e) {
          final actModel = ActivityModel.fromMap(Map<String, dynamic>.from(e));
          if (actModel.shareType == 'PUB') {
            //---( Adding All Public Event TO List )---//
            allPublicEventList.add(actModel);
          } else if (actModel.shareType == 'FOL') {
            //---( Adding Alll Following Event To List )---//
            allFollowings.forEach((element) {
              if (actModel.creatorId == element) {
                allFollowingEventList.add(actModel);
                return;
              }
            });
          } else if (actModel.shareType == 'COM') {
            //---( Adding All Communites Event To List )---//
            allCommunities.forEach((element) {
              if (actModel.communities.contains(element)) {
                allCommunityEventList.add(actModel);
                return;
              }
            });
          } else if (actModel.shareType == 'CON') {
            //---( Adding All Connection Event To List )---//
            allFriends.forEach((element) {
              if (actModel.creatorId == element) {
                allConnectionEventList.add(actModel);
              }
            });
          }
        });
        //---( Making Visible List of Events )---//
        allEventsVisibleList.addAll(allConnectionEventList);
        allEventsVisibleList.addAll(allFollowingEventList);
        allEventsVisibleList.addAll(allCommunityEventList);

        //---( Making Search List for all Public + Visible Events )---//
        allEventsSearchList.addAll(allEventsVisibleList);
        allEventsSearchList.addAll(allPublicEventList);
        notifyListeners();
      }
    });
  }

  void _fetchCurrentCommunities() {
    allCommunities.clear();
    final _chatListDB = FirebaseDatabase.instance.reference().child('Channels');
    _chatListDB
        .child(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final Map map = snapshot.value;
        map.values.forEach((element) {
          final model = ChatListModel.fromMap(element);
          if (model.user == _auth.currentUser!.uid) {
            allCommunities.add(model.chid);
          }
        });
      }
    });
  }

  void _fetchCurrentFriendsList() {
    allFriends.clear();
    final _friendDB = FirebaseDatabase.instance.reference().child('Friends');
    _friendDB
        .child(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final Map map = snapshot.value;
        map.values.forEach((element) {
          allFriends.add(FriendsModel.fromMap(element).uid);
        });
      }
    });
  }

  void _fetchCurrentFollowing() {
    allFollowings.clear();
    final _followingDB =
        FirebaseDatabase.instance.reference().child('Following');
    _followingDB
        .child(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final Map map = snapshot.value;
        map.values.forEach((element) {
          allFollowings.add(FollowerModel.fromMap(element).uid);
        });
      }
    });
  }

  void _fetchCommunity() {
    _communityStream = _communityDB
        .orderByChild('type')
        .equalTo('COM')
        .onValue
        .listen((event) {
      if (event.snapshot.value == null) {
        allCommunity.clear();
        notifyListeners();
      } else {
        final _allCommnityMap = Map<String, dynamic>.from(event.snapshot.value);
        allCommunity = _allCommnityMap.values.map((e) {
          final comModel = GroupChannel.fromMap(Map<String, dynamic>.from(e));
          return CommunitySearchHelper(
            groupChannel: comModel,
            isPending: comModel.requests.contains(_auth.currentUser!.uid) ||
                comModel.users.contains(_auth.currentUser!.uid),
          );
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
    filteredEventsList = allEventsSearchList;
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
          .where((element) =>
              element.searchTag.toLowerCase().contains(filter.toLowerCase()))
          .toList();
      filteredEventsList = newEventFilter;

      final newCommunityFilter = filteredCommunity
          .where((element) => element.groupChannel.chName
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

//---( Here Community Model Class )---//
class CommunitySearchHelper with ChangeNotifier {
  bool isPending;
  GroupChannel groupChannel;

  CommunitySearchHelper({
    required this.groupChannel,
    this.isPending = false,
  });

  void toggleRequest() {
    isPending = true;
    notifyListeners();
  }
}
