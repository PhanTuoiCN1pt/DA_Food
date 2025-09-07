import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/food_model.dart';

class FoodProvider with ChangeNotifier {
  FoodItem? _food;
  bool _isNew = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  FoodItem get food {
    _food ??= FoodItem(
      id: '',
      userId: '',
      category: 'Chưa xác định',
      name: '',
      quantity: 1,
      location: 'Tủ lạnh',
      subLocation: '',
      registerDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      note: '',
    );
    return _food!;
  }

  bool get isNew => _isNew;

  /// Khởi tạo một food mới
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

  /// Init từ FoodItem có sẵn (dùng khi edit)
  void initFoodFromItem(FoodItem item) {
    _food = item;
    _isNew = false;
    nameController.text = item.name;
    noteController.text = item.note;
    notifyListeners();
  }

  void updateName(String name) {
    if (_food != null) {
      _food!.name = name;
      notifyListeners();
    }
  }

  void updateQuantity(int quantity) {
    if (_food != null) {
      _food!.quantity = quantity;
      notifyListeners();
    }
  }

  void updateLocation(String location) {
    if (_food != null) {
      _food!.location = location;
      notifyListeners();
    }
  }

  void updateSubLocation(String subLocation) {
    if (_food != null) {
      _food!.subLocation = subLocation;
      notifyListeners();
    }
  }

  void updateRegisterDate(DateTime date) {
    if (_food != null) {
      _food!.registerDate = date;
      notifyListeners();
    }
  }

  void updateExpiryDate(DateTime date) {
    if (_food != null) {
      _food!.expiryDate = date;
      notifyListeners();
    }
  }

  void updateNote(String note) {
    if (_food != null) {
      _food!.note = note;
      notifyListeners();
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
