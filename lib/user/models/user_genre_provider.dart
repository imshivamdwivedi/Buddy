import 'package:buddy/user/models/category_class.dart';
import 'package:flutter/material.dart';

class UserGenreProvider with ChangeNotifier {
  List<Category> genreList = [];
  String userName = 'User Name';

  void addList(List<Category> value) {
    genreList.clear();
    genreList.addAll(value);
    notifyListeners();
  }

  void setName(String name) {
    userName = name;
    notifyListeners();
  }

  List<Category> get allGenre {
    return [...genreList];
  }

  List<Category> get onlySelected {
    return genreList.where((element) => element.isSelected).toList();
  }

  Category genreByText(String text) {
    return genreList.firstWhere((element) => element.name == text);
  }
}
