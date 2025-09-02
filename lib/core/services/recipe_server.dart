import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeService {
  static const String baseUrl = "http://192.168.0.105:5000/api/meals/category";

  static Future<List<Map<String, dynamic>>> fetchRecipesByCategory(
    String category,
  ) async {
    final response = await http.get(Uri.parse("$baseUrl/$category"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // API trả về { recipes: [...] }
      return List<Map<String, dynamic>>.from(data["recipes"]);
    } else {
      throw Exception("Không lấy được danh sách món ăn");
    }
  }
}
