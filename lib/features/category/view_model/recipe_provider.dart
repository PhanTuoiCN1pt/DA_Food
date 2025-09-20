import 'package:da_food/features/food/model/recipe_model.dart';
import 'package:flutter/material.dart';

import '../../../core/services/recipe_service.dart';

class RecipesProvider extends ChangeNotifier {
  final String category;
  bool isLoading = false;
  Map<String, List<RecipeModel>> recipesBySub = {};

  RecipesProvider(this.category);

  Future<void> loadRecipes() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await RecipeService.fetchRecipesByCategory(category);

      Map<String, List<RecipeModel>> grouped = {};
      for (var r in data) {
        final sub = r.subCategory ?? "Khác";
        grouped.putIfAbsent(sub, () => []);
        grouped[sub]!.add(r);
      }

      recipesBySub = grouped;
    } catch (e) {
      debugPrint("❌ Lỗi lấy món ăn theo danh mục: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
