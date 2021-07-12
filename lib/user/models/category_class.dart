import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String name;
  final int id;
  int count;
  bool isSelected;

  Category({
    required this.name,
    required this.id,
    required this.count,
    this.isSelected = false,
  });

  void toggleSelected() {
    isSelected = !isSelected;
    notifyListeners();
  }

  factory Category.fromMap(Map map) {
    return Category(
      name: map['name'],
      id: map['id'],
      count: map['count'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        'count': count,
      };
}
