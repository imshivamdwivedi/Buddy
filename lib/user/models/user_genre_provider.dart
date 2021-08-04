import 'package:buddy/constants.dart';
import 'package:buddy/user/models/category_class.dart';
import 'package:flutter/material.dart';

class UserGenreProvider with ChangeNotifier {
  List<Category> genreList = [];
  List<Category> topGenreList = [];
  static List<Category> catList = [];
  String userName = '';
  static String queryFin = '';

  String get getQuery {
    return queryFin;
  }

  void addList(List<Category> value) {
    value.sort((a, b) => a.count > b.count ? -1 : 1);
    genreList.clear();
    genreList.addAll(value);
    catList.clear();
    catList.addAll(value);
    topGenreList.clear();
    for (int i = 0; i < 6; i++) {
      topGenreList.add(value[i]);
    }
    notifyListeners();
  }

  void addPreGenre(String string) {
    if (string == '') {
      return;
    }
    final idList = string.split(splitCode);
    topGenreList.clear();
    idList.forEach((genreTemp) {
      final tempGenre =
          genreList.firstWhere((element) => element.id == genreTemp);
      tempGenre.isSelected = true;
      topGenreList.add(tempGenre);
    });
  }

  void addGenre(Category category) {
    category.isSelected = true;
    if (!topGenreList.contains(category)) {
      topGenreList.add(category);
      notifyListeners();
    } else {
      topGenreList.forEach((element) {
        if (element == category) {
          element.isSelected = true;
          notifyListeners();
        }
      });
    }
  }

  void createGenre(Category category) {
    category.isSelected = true;
    category.isNew = true;
    topGenreList.add(category);
    catList.add(category);
    notifyListeners();
  }

  List<Category> get topGenre {
    return [...topGenreList];
  }

  void setName(String name) {
    userName = name;
    notifyListeners();
  }

  List<Category> get allGenre {
    return [...genreList];
  }

  static List<Category> get catGenre {
    return [...catList];
  }

  List<Category> get onlySelected {
    return topGenreList.where((element) => element.isSelected).toList();
  }
}

class CategoryAPI extends UserGenreProvider {
  static List<Category> getUserSuggestion(String query) {
    UserGenreProvider.queryFin = query;
    if (query.length < 3) {
      return [];
    }
    List<Category> lists = UserGenreProvider.catGenre;
    return lists
        .where((category) => category.name
            .toString()
            .toLowerCase()
            .startsWith(query.toLowerCase()))
        .toList();
  }
}
