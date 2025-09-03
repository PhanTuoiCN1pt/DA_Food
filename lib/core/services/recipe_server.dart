import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeService {
  static const String baseUrl = "http://192.168.0.105:5000/api/recipes";
  // ⚠️ Nếu chạy device thật thì đổi 10.0.2.2 thành IP LAN của server

  /// Lấy toàn bộ công thức
  static Future<List<Map<String, dynamic>>> getRecipes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("❌ Lỗi lấy công thức");
    }
  }

  /// Tạo công thức mới
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

  /// Thêm công thức vào Nhà bếp (có location)
  static Future<Map<String, dynamic>> addToKitchen(String recipeId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/kitchen/$recipeId"), // gọi API update
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"location": "Nhà bếp"}), // chỉ update location
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Lỗi thêm vào Nhà bếp");
    }
  }

  /// Lấy danh sách công thức trong Nhà bếp
  static Future<List<Map<String, dynamic>>> getKitchenRecipes() async {
    final response = await http.get(Uri.parse("$baseUrl/kitchen"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("❌ Lỗi lấy danh sách Nhà bếp");
    }
  }

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
