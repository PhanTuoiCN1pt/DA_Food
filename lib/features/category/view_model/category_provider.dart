import 'package:flutter/material.dart';

import '../../../core/services/category_service.dart';
import '../../../core/services/recipe_service.dart';
import '../../food/model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  List<Map<String, dynamic>> recipeCategories = [];
  bool isLoadingRecipe = false;

  List<Category> allCategories = [];
  List<Map<String, dynamic>> apiSubCategories = [];
  bool isLoadingSub = false;

  void selectCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Load toàn bộ category từ API backend
  Future<void> loadCategories() async {
    try {
      final data = await CategoryService().fetchCategories();
      allCategories = data;
      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi load categories: $e");
    }
  }

  /// Load subCategory của "Món ăn" (RecipeService)
  Future<void> loadRecipeCategories() async {
    isLoadingRecipe = true;
    notifyListeners();
    try {
      final data = await RecipeService.fetchMealCategories();
      recipeCategories = data;
    } catch (e) {
      debugPrint("Lỗi lấy danh mục món ăn: $e");
    } finally {
      isLoadingRecipe = false;
      notifyListeners();
    }
  }

  /// Load subCategories theo categoryId
  Future<void> loadSubCategories(String categoryId) async {
    isLoadingSub = true;
    notifyListeners();
    try {
      if (allCategories.isEmpty) {
        await loadCategories();
      }
      final selected = allCategories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => Category(id: "", icon: "", label: "", subCategories: []),
      );
      apiSubCategories = selected.subCategories
          .map((e) => {"icon": e.icon, "label": e.label, "_id": e.id})
          .toList();
    } catch (e) {
      debugPrint("Lỗi load subCategories: $e");
    } finally {
      isLoadingSub = false;
      notifyListeners();
    }
  }
}
