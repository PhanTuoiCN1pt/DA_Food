import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../connect/api_url.dart';
import '../../features/food/model/recipe_model.dart';
import '../../helper/category_icon_helper.dart';

class RecipeService {
  static final String recipeBaseUrl = "$apiUrl/api/recipes";

  /// ================== CATEGORY ==================
  static Future<List<Map<String, dynamic>>> fetchMealCategories() async {
    final response = await http.get(Uri.parse("$recipeBaseUrl/categories"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> categories = data["categories"];

      return categories
          .map((cat) => {"label": cat, "icon": CategoryIconHelper.getIcon(cat)})
          .toList();
    } else {
      throw Exception("Không lấy được danh mục món ăn");
    }
  }

  static Future<List<RecipeModel>> fetchRecipesByCategory(
    String category,
  ) async {
    final url = Uri.parse("$recipeBaseUrl/category/$category");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List recipes = data["recipes"] ?? [];
      return recipes.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi API: ${response.statusCode}");
    }
  }

  /// ================== RECIPE ==================
  static Future<List<RecipeModel>> getRecipes() async {
    final response = await http.get(Uri.parse(recipeBaseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi lấy công thức");
    }
  }

  static Future<RecipeModel> createRecipe(RecipeModel recipe) async {
    final response = await http.post(
      Uri.parse(recipeBaseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(recipe.toJson()),
    );

    if (response.statusCode == 201) {
      return RecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Lỗi tạo công thức");
    }
  }

  /// ================== KITCHEN ==================
  static Future<RecipeModel> addToKitchen(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) {
      throw Exception("Không tìm thấy userId trong SharedPreferences");
    }

    final response = await http.put(
      Uri.parse("$recipeBaseUrl/kitchen/$recipeId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Lỗi thêm vào Nhà bếp");
    }
  }

  static Future<List<RecipeModel>> getKitchenRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) {
      throw Exception("Không tìm thấy userId trong SharedPreferences");
    }

    final response = await http.get(
      Uri.parse("$recipeBaseUrl/kitchen?userId=$userId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi lấy danh sách Nhà bếp");
    }
  }

  static Future<bool> removeFromKitchen(String recipeId) async {
    final response = await http.delete(
      Uri.parse("$recipeBaseUrl/kitchen/delete/$recipeId"),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Lỗi xóa món ăn khỏi Nhà bếp");
    }
  }

  /// ================== LOCATION ==================
  static Future<List<RecipeModel>> fetchRecipesByLocation(
    String location,
  ) async {
    final response = await http.get(
      Uri.parse("$recipeBaseUrl/location/$location"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => RecipeModel.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi lấy món ăn theo vị trí");
    }
  }

  /// ================== Gợi ý thực đơn ==================
  static Future<List<RecipeModel>> getMealSuggestions(String userId) async {
    final url = Uri.parse("$recipeBaseUrl/suggestions/$userId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final suggestionsJson = data['suggestions'] as List<dynamic>? ?? [];
      return suggestionsJson.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception("Lỗi khi hiển thị thực đơn");
    }
  }
}
