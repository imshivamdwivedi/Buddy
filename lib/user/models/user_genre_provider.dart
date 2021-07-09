import 'package:buddy/user/models/item_model.dart';
import 'package:flutter/material.dart';

class UserGenreProvider with ChangeNotifier {
  List<ItemModel> genreList = [];
  String userName = 'User Name';

  void addList(List<ItemModel> value) {
    genreList.clear();
    genreList.addAll(value);
    notifyListeners();
  }

  void setName(String name) {
    userName = name;
    notifyListeners();
  }

  List<ItemModel> get allGenre {
    return [...genreList];
  }

  List<ItemModel> get onlySelected {
    return genreList.where((element) => element.isSelected).toList();
  }

  ItemModel genreByText(String text) {
    return genreList.firstWhere((element) => element.text == text);
  }
}
