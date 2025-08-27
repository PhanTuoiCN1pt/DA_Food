import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/food_model.dart';

class FoodProvider with ChangeNotifier {
  FoodItem? _food;
  bool _isNew = true;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  FoodItem get food => _food!;
  bool get isNew => _isNew;

  Future<void> initFood({
    required String category,
    required String name,
  }) async {
    _isNew = true;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    _food = FoodItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      category: category,
      name: name,
      quantity: 1,
      location: "Tủ lạnh",
      subLocation: "Không xác định",
      registerDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      note: "",
    );

    nameController.text = _food!.name;
    noteController.text = _food!.note;
    notifyListeners();
  }

  void initFoodFromItem(FoodItem item) {
    _food = item;
    _isNew = false;
    nameController.text = item.name;
    noteController.text = item.note;
    notifyListeners();
  }

  // ============= Update field =============
  void updateName(String name) {
    _food?.name = name;
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    _food?.quantity = quantity;
    notifyListeners();
  }

  void updateLocation(String loc) {
    _food?.location = loc;
    notifyListeners();
  }

  void updateSubLocation(String subLoc) {
    _food?.subLocation = subLoc;
    notifyListeners();
  }

  void updateRegisterDate(DateTime date) {
    _food?.registerDate = date;
    notifyListeners();
  }

  void updateExpiryDate(DateTime date) {
    _food?.expiryDate = date;
    notifyListeners();
  }

  void updateNote(String note) {
    _food?.note = note;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => _food?.toJson() ?? {};

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
