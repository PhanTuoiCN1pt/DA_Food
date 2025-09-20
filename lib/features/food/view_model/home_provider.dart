import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/food_service.dart';
import '../../../core/services/recipe_service.dart';
import '../../../core/services/user_service.dart';
import '../../food/model/food_model.dart';
import '../model/recipe_model.dart';
import '../model/user_model.dart';

class HomeProvider extends ChangeNotifier {
  UserModel? user;
  List<FoodItem> fridgeFoods = [];
  List<FoodItem> freezerFoods = [];
  List<RecipeModel> recipes = [];

  bool loading = true;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";
    if (userId.isNotEmpty) {
      try {
        user = await UserService.fetchUserById(userId);
      } catch (e) {
        debugPrint("❌ Error fetching user: $e");
      }
    }
    notifyListeners();
  }

  Future<void> loadFoods() async {
    loading = true;
    notifyListeners();
    try {
      final foods = await FoodService.fetchFoods();
      fridgeFoods = foods.where((f) => f.location == "Ngăn lạnh").toList();
      freezerFoods = foods.where((f) => f.location == "Ngăn đông").toList();
    } catch (e) {
      debugPrint("❌ Lỗi load foods: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadKitchen() async {
    loading = true;
    notifyListeners();
    try {
      recipes = await RecipeService.getKitchenRecipes();
    } catch (e) {
      debugPrint("❌ Lỗi load kitchen: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> reloadAll() async {
    await Future.wait([loadUser(), loadFoods(), loadKitchen()]);
  }
}
