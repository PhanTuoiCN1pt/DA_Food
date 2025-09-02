import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helper/category_icon_helper.dart';

class MealCategoryService {
  static const String baseUrl =
      "http://192.168.0.105:5000/api/meals/categories";

  static Future<List<Map<String, dynamic>>> fetchMealCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // API trả về { "categories": ["Món chính", "Tráng miệng", "Đồ uống"] }
      final List<dynamic> categories = data["categories"];

      return categories
          .map((cat) => {"label": cat, "icon": CategoryIconHelper.getIcon(cat)})
          .toList();
    } else {
      throw Exception("Không lấy được danh mục món ăn");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRecipesByCategory(
    String category,
  ) async {
    final url = Uri.parse(
      "http://192.168.0.105:5000/api/meals/category/$category",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Lấy danh sách recipes (nếu không có thì trả về [])
      final List recipes = data["recipes"] ?? [];

      // Convert sang List<Map<String, dynamic>>
      return recipes.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("❌ Lỗi API: ${response.statusCode}");
    }
  }
}
