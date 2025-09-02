import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/food/model/food_model.dart';
import '../../features/food/model/recipe_model.dart';
import '../../helper/loader.dart';

class FoodService {
  static const baseUrl = "http://192.168.0.105:5000/api/foods";
  static const mealUrl = "http://192.168.0.105:5000/api/meals/suggestions";

  /// Thêm food và tự lấy userId từ SharedPreferences
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
      Loaders.successSnackBar(
        title: "Thành công",
        message: "Bạn đã thêm thanh công thực phẩm!",
      );
      return FoodItem.fromJson(jsonDecode(response.body));
    } else {
      Loaders.errorSnackBar(
        title: "Lỗi!",
        message: "Vui lòng kiểm tra lại kết nối mạng!",
      );
      throw Exception("Failed to add food: ${response.body}");
    }
  }

  static Future<FoodItem> updateFood(FoodItem food) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${food.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(food.toJson()),
    );
    if (res.statusCode == 200) {
      Loaders.successSnackBar(
        title: "Thành công",
        message: "Bạn đã cập nhật thành công thực phẩm!",
      );
      return FoodItem.fromJson(jsonDecode(res.body));
    } else {
      Loaders.errorSnackBar(
        title: "Lỗi!",
        message: "Vui lòng kiểm tra lại kết nối mạng!",
      );
      throw Exception("Failed to update food: ${res.body}");
    }
  }

  static Future<List<FoodItem>> fetchFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    print("UserId from SharedPreferences: $userId");
    final response = await http.get(Uri.parse("$baseUrl?userId=$userId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FoodItem.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load foods: ${response.statusCode}");
    }
  }

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

  static Future<void> deleteFood(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete food: ${response.statusCode}");
    }
  }

  // Gợi ý thực đơn
  static Future<List<RecipeModel>> getMealSuggestions(String userId) async {
    final url = Uri.parse("$mealUrl/$userId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final suggestionsJson = data['suggestions'] as List<dynamic>? ?? [];
      return suggestionsJson.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch meal suggestions");
    }
  }
}
