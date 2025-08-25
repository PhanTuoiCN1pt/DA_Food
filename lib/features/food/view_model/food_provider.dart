import 'package:flutter/material.dart';

import '../../../core/services/food_server.dart';
import '../model/food_model.dart';
import 'foods_provider.dart';

class FoodProvider with ChangeNotifier {
  FoodItem? _food;
  bool _isNew = true;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  FoodItem get food => _food!;
  bool get isNew => _isNew;

  void initFood({required String category, required String name}) {
    _isNew = true;
    _food = FoodItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  // ============= Save to backend =============
  Future<void> saveFood(FoodsProvider foodsProvider) async {
    if (_food == null) return;

    try {
      if (_food!.id.isEmpty) {
        // Chưa có id => thêm mới
        final newFood = await FoodService.addFood(_food!);
        _food = newFood;
        foodsProvider.addFood(newFood);
      } else {
        // Có id => update
        final updated = await FoodService.updateFood(_food!);
        _food = updated;
        foodsProvider.updateFood(updated);
      }
    } catch (e) {
      debugPrint("❌ saveFood error: $e");
    }
  }

  Map<String, dynamic> toJson() => _food?.toJson() ?? {};

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
