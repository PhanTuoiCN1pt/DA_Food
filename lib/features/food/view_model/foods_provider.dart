import 'package:flutter/material.dart';

import '../model/food_model.dart';

class FoodsProvider with ChangeNotifier {
  final List<FoodItem> _foods = [];

  List<FoodItem> get foods => _foods;

  /// Thêm thực phẩm
  void addFood(FoodItem food) {
    _foods.add(food);
    notifyListeners();
  }

  /// Xóa thực phẩm
  void removeFood(FoodItem food) {
    _foods.remove(food);
    notifyListeners();
  }

  /// Cập nhật tên
  void updateName(FoodItem food, String name) {
    food.name = name;
    notifyListeners();
  }

  /// Cập nhật số lượng
  void updateQuantity(FoodItem food, int quantity) {
    food.quantity = quantity;
    notifyListeners();
  }

  /// Lấy danh sách theo location (tủ lạnh, tủ đông, nhà bếp)
  List<FoodItem> getFoodsByLocation(String location) {
    return _foods.where((f) => f.location == location).toList();
  }

  /// Gom nhóm theo location để hiển thị
  Map<String, List<FoodItem>> get groupedFoods {
    Map<String, List<FoodItem>> map = {};
    for (var food in _foods) {
      map.putIfAbsent(food.location, () => []);
      map[food.location]!.add(food);
    }
    return map;
  }
}
