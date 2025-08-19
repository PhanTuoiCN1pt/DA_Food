import 'package:flutter/material.dart';

import '../model/food_model.dart';

class FoodProvider with ChangeNotifier {
  late FoodItem _food;

  // Controllers để gắn vào TextField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  FoodItem get food => _food;

  void initFood(String category, String name) {
    _food = FoodItem(category: category, name: name);

    // đồng bộ model <-> controller
    nameController.text = _food.name;
    noteController.text = _food.note;
  }

  void updateName(String name) {
    _food.name = name;
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    _food.quantity = quantity;
    notifyListeners();
  }

  void updateLocation(String loc) {
    _food.location = loc;
    notifyListeners();
  }

  void updateSubLocation(String subLoc) {
    _food.subLocation = subLoc;
    notifyListeners();
  }

  void updateRegisterDate(DateTime date) {
    _food.registerDate = date;
    notifyListeners();
  }

  void updateExpiryDate(DateTime date) {
    _food.expiryDate = date;
    notifyListeners();
  }

  void updateNote(String note) {
    _food.note = note;
    notifyListeners();
  }

  // cleanup khi không dùng nữa
  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
