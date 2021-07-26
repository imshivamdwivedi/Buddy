import 'package:buddy/notification/model/friends_model.dart';
import 'package:flutter/cupertino.dart';

class ChatSearchProvider with ChangeNotifier {
  static List<FriendsModel> friendsList = [];

  static List<FriendsModel> get allFriendsList {
    return [...friendsList];
  }

  void setFriendsList(List<FriendsModel> friends) {
    friendsList.clear();
    friendsList.addAll(friends);
    notifyListeners();
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
