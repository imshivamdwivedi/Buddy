import 'package:buddy/user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel _userModel = new UserModel(profile: true);
  static List<UserModel> userList = [];

  void updateUserData(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  String getUserName() {
    return _userModel.firstName + ' ' + _userModel.lastName;
  }

  String getUserCollege() {
    return _userModel.collegeName;
  }

  static List<UserModel> get UserList {
    return [...userList];
  }
}

class UserAPI extends UserProvider {
  static List<UserModel> getUserSuggestion(String query) {
    List<UserModel> lists = UserProvider.UserList;
    return lists
        .where((user) => (user.firstName + user.lastName)
            .toString()
            .toLowerCase()
            .startsWith(query.toLowerCase()))
        .toList();
  }
}
