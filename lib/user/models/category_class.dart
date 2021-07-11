import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String name;
  final int id;
  bool isSelected;

  Category({
    required this.name,
    required this.id,
    this.isSelected = false,
  });

  void toggleSelected() {
    isSelected = !isSelected;
    notifyListeners();
  }
}
