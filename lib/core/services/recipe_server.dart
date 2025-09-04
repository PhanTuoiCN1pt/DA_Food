import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService {
  static const String baseUrl = "http://192.168.0.105:5000/api/recipes";
  // ⚠️ Nếu chạy device thật thì đổi thành IP LAN của server

  /// Lấy toàn bộ công thức gốc
  static Future<List<Map<String, dynamic>>> getRecipes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("❌ Lỗi lấy công thức");
    }
  }

  /// Tạo công thức mới (gốc)
  static Future<Map<String, dynamic>> createRecipe(
    Map<String, dynamic> recipe,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(recipe),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Lỗi tạo công thức");
    }
  }

  /// Thêm công thức vào Nhà bếp của user
  static Future<Map<String, dynamic>> addToKitchen(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) {
      throw Exception("❌ Không tìm thấy userId trong SharedPreferences");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/kitchen/$recipeId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Lỗi thêm vào Nhà bếp");
    }
  }

  /// Lấy danh sách công thức trong Nhà bếp của user hiện tại
  static Future<List<Map<String, dynamic>>> getKitchenRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) {
      throw Exception("❌ Không tìm thấy userId trong SharedPreferences");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/kitchen?userId=$userId"), // query userId
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("❌ Lỗi lấy danh sách Nhà bếp");
    }
  }

  /// Lấy recipes theo location
  static Future<List<Map<String, dynamic>>> fetchRecipesByLocation(
    String location,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/location/$location"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("❌ Lỗi lấy recipes theo location");
    }
  }
}
