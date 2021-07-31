import 'package:buddy/user/models/user_model.dart';
import 'package:flutter/cupertino.dart';

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
    if (query == '') {
      filteredUsersList = [...allUsersList];
      notifyListeners();
    }
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
