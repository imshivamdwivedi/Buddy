import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String name;
  final String id;
  int count;
  bool isSelected;
  bool isNew;

  Category({
    required this.name,
    required this.id,
    required this.count,
    this.isSelected = false,
    this.isNew = false,
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
