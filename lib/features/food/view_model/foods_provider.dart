import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/food_model.dart';

class FoodsProvider with ChangeNotifier {
  List<FoodItem> _foods = [];
  List<FoodItem> get foods => _foods;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String baseUrl = "http://192.168.0.105:5000/api/foods";

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Lấy danh sách thực phẩm từ API
  Future<void> fetchFoods() async {
    _setLoading(true);
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _foods = data.map((json) => FoodItem.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load foods: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ fetchFoods error: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Thêm local (không gọi API)
  void addFoodLocal(FoodItem food) {
    _foods.add(food);
    notifyListeners();
  }

  /// Gửi API thêm thực phẩm
  Future<void> addFood(FoodItem food) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(food.toJson()),
      );

      if (response.statusCode == 201) {
        final newFood = FoodItem.fromJson(jsonDecode(response.body));
        _foods.add(newFood);
      } else {
        throw Exception("Failed to add food: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ addFood error: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Gửi API cập nhật thực phẩm
  Future<void> updateFood(FoodItem food) async {
    _setLoading(true);
    try {
      final url = "$baseUrl/${food.id}";
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(food.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedFood = FoodItem.fromJson(jsonDecode(response.body));
        final index = _foods.indexWhere((f) => f.id == food.id);
        if (index != -1) {
          _foods[index] = updatedFood;
        }
      } else {
        throw Exception("Failed to update food: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ updateFood error: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Gửi API xoá thực phẩm
  Future<void> deleteFood(String id) async {
    _setLoading(true);
    try {
      final url = "$baseUrl/$id";
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _foods.removeWhere((f) => f.id == id);
      } else {
        throw Exception("Failed to delete food: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ deleteFood error: $e");
    } finally {
      _setLoading(false);
    }
  }
}
