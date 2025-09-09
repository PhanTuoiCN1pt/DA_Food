import 'package:flutter/material.dart';

import '../../../core/services/recipe_service.dart';
import '../../food/model/recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  /// Danh mục
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> get categories => _categories;

  /// Công thức
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> get recipes => _recipes;

  /// Nhà bếp
  List<Map<String, dynamic>> _kitchenRecipes = [];
  List<Map<String, dynamic>> get kitchenRecipes => _kitchenRecipes;

  /// Gợi ý
  List<RecipeModel> _mealSuggestions = [];
  List<RecipeModel> get mealSuggestions => _mealSuggestions;

  /// Trạng thái
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  /// ================== API ==================

  Future<void> fetchCategories() async {
    try {
      _setLoading(true);
      _categories = await RecipeService.fetchMealCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> fetchRecipesByCategory(String category) async {
    try {
      _setLoading(true);
      _recipes = await RecipeService.fetchRecipesByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> fetchAllRecipes() async {
    try {
      _setLoading(true);
      _recipes = await RecipeService.getRecipes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    try {
      final newRecipe = await RecipeService.createRecipe(recipe);
      _recipes.add(newRecipe);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> addToKitchen(String recipeId) async {
    try {
      final added = await RecipeService.addToKitchen(recipeId);
      _kitchenRecipes.add(added);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> fetchKitchenRecipes() async {
    try {
      _setLoading(true);
      _kitchenRecipes = await RecipeService.getKitchenRecipes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> removeFromKitchen(String recipeId) async {
    try {
      await RecipeService.removeFromKitchen(recipeId);
      _kitchenRecipes.removeWhere((r) => r["_id"] == recipeId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> fetchMealSuggestions(String userId) async {
    try {
      _setLoading(true);
      _mealSuggestions = await RecipeService.getMealSuggestions(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
}
