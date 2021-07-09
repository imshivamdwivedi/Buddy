import 'package:flutter/material.dart';

class ItemModel with ChangeNotifier {
  String text;
  bool isSelected;

  ItemModel({
    required this.text,
    this.isSelected = false,
  });

  void toggleSelected() {
    isSelected = !isSelected;
    notifyListeners();
  }
}
