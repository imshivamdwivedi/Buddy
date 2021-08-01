import 'package:buddy/user/models/user_model.dart';
import 'package:flutter/material.dart';

class HomeSearchProvider with ChangeNotifier {
  final List<HomeSearchHelper> allUsersList = [];
  List<HomeSearchHelper> filteredUsersList = [];

  List<HomeSearchHelper> get suggestedUsers {
    return [...filteredUsersList];
  }

  void setAllUsers(List<HomeSearchHelper> users) {
    allUsersList.clear();
    allUsersList.addAll(users);
    notifyListeners();
  }

  void updateQuery(String query) {
    filteredUsersList.clear();
    final filters = query.trim().split(' ');
    if (query == '') {
      filteredUsersList = [...allUsersList];
      notifyListeners();
      return;
    }

    filters.forEach((filter) {
      allUsersList.forEach((element) {
        if (element.userModel.searchTag.contains(filter)) {
          addToFilteredList(element);
        }
      });
    });

    notifyListeners();
  }

  void addToFilteredList(HomeSearchHelper model) {
    if (!filteredUsersList.contains(model)) {
      filteredUsersList.add(model);
    }
  }
}

//H://---( Here Model Class )---//
class HomeSearchHelper with ChangeNotifier {
  UserModel userModel;
  //int count;
  bool isPending;
  bool isFriend;

  HomeSearchHelper({
    required this.userModel,
    //this.count = 0,
    this.isPending = false,
    this.isFriend = false,
  });

  void toggleFriend() {
    isPending = true;
    notifyListeners();
  }

  // void updateCount(int newCount) {
  //   count = newCount;
  // }
}
