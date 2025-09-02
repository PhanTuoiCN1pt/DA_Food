import 'package:da_food/features/category/view/recipe_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/services/meal_category_server.dart';

class RecipesByCategoryScreen extends StatefulWidget {
  final String category;

  const RecipesByCategoryScreen({super.key, required this.category});

  @override
  State<RecipesByCategoryScreen> createState() =>
      _RecipesByCategoryScreenState();
}

class _RecipesByCategoryScreenState extends State<RecipesByCategoryScreen> {
  List<Map<String, dynamic>> recipes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    setState(() => isLoading = true);
    try {
      final data = await MealCategoryService.fetchRecipesByCategory(
        widget.category,
      );
      setState(() {
        recipes = data;
      });
    } catch (e) {
      debugPrint("❌ Lỗi lấy món ăn theo category: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipes.isEmpty
          ? const Center(child: Text("Không có món ăn nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  child: ListTile(
                    title: Text(recipe["name"] ?? "Không có tên"),
                    subtitle: Text(
                      "Nguyên liệu: ${recipe["ingredients"]?.length ?? 0}",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
