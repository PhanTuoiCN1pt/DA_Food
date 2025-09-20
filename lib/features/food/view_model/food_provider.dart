import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/food_service.dart';
import '../model/food_model.dart';

class FoodProvider with ChangeNotifier {
  // ---------- STATE CHI TIẾT 1 FOOD ----------
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
      location: 'Ngăn lạnh',
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
      location: "Ngăn lạnh",
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
    // notifyListeners();
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

  // ---------- STATE DANH SÁCH FOODS ----------
  List<FoodItem> _foods = [];
  List<FoodItem> get foods => _foods;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Lấy danh sách food
  Future<void> fetchFoods() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _foods = await FoodService.fetchFoods();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Thêm food
  Future<void> addFood(FoodItem food) async {
    try {
      final newFood = await FoodService.addFood(food);
      _foods.add(newFood);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Cập nhật food
  Future<void> updateFood(FoodItem food) async {
    try {
      final updatedFood = await FoodService.updateFood(food);
      final index = _foods.indexWhere((f) => f.id == food.id);
      if (index != -1) {
        _foods[index] = updatedFood;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Xóa food
  Future<void> deleteFood(String id) async {
    try {
      await FoodService.deleteFood(id);
      _foods.removeWhere((f) => f.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Lấy food theo ID
  Future<FoodItem?> getFoodById(String id) async {
    try {
      return await FoodService.getFoodById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
