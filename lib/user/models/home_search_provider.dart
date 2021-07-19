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
  // void addUser(HomeSearchHelper model) {
  //   allUsers.add(model);
  //   notifyListeners();
  // }

  // void updateUser(HomeSearchHelper model) {
  //   final index = allUsers.indexWhere((element) => element.id == model.id);
  //   allUsers[index] = model;
  //   notifyListeners();
  // }
}

class HomeSearchHelper with ChangeNotifier {
  UserModel userModel;
  bool isFriend;

  HomeSearchHelper({
    required this.userModel,
    this.isFriend = false,
  });

  void toggleFriend() {
    isFriend = !isFriend;
    notifyListeners();
  }
}
