import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  String? _selectedCategory;

  String? get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
