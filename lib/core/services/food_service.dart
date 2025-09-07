import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/food/model/food_model.dart';

class FoodService {
  static const baseUrl = "http://192.168.0.103:5000/api/foods";

  /// Thêm food, tự lấy userId từ SharedPreferences
  static Future<FoodItem> addFood(FoodItem food) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final body = food.toJson();
    body['userId'] = userId;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return FoodItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add food: ${response.body}");
    }
  }

  /// Cập nhật thông tin food
  static Future<FoodItem> updateFood(FoodItem food) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${food.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(food.toJson()),
    );

    if (res.statusCode == 200) {
      return FoodItem.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to update food: ${res.body}");
    }
  }

  /// Lấy danh sách food của user
  static Future<List<FoodItem>> fetchFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final response = await http.get(Uri.parse("$baseUrl?userId=$userId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FoodItem.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load foods: ${response.statusCode}");
    }
  }

  /// Lấy food theo ID
  static Future<FoodItem> getFoodById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final response = await http.get(Uri.parse("$baseUrl/$id?userId=$userId"));

    if (response.statusCode == 200) {
      return FoodItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Food not found: ${response.statusCode}");
    }
  }

  /// Xóa food theo ID
  static Future<void> deleteFood(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete food: ${response.statusCode}");
    }
  }
}
