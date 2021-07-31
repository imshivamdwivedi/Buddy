import 'package:buddy/user/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class HomeSearchProvider with ChangeNotifier {
  final List<HomeSearchHelper> allUsers = [];

  List<HomeSearchHelper> get suggestedUsers {
    return [...allUsers];
  }

  void setAllUsers(List<HomeSearchHelper> users) {
    allUsers.clear();
    allUsers.addAll(users);
    notifyListeners();
  }
}

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
