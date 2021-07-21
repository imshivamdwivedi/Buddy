import 'package:buddy/user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel _userModel = new UserModel(profile: true);

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
}
