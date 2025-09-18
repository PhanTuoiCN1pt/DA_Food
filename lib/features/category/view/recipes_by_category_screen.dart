import 'package:da_food/features/food/model/recipe_model.dart';
import 'package:flutter/material.dart';

import '../../../core/services/recipe_service.dart';
import '../view/recipe_detail_screen.dart';

class RecipesBySubCategoryScreen extends StatefulWidget {
  final String category; // Category cha

  const RecipesBySubCategoryScreen({super.key, required this.category});

  @override
  State<RecipesBySubCategoryScreen> createState() =>
      _RecipesBySubCategoryScreenState();
}

class _RecipesBySubCategoryScreenState
    extends State<RecipesBySubCategoryScreen> {
  Map<String, List<RecipeModel>> recipesBySub = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    setState(() => isLoading = true);
    try {
      final data = await RecipeService.fetchRecipesByCategory(widget.category);

      // Gom theo subCategory
      Map<String, List<RecipeModel>> grouped = {};
      for (var r in data) {
        final sub = r.subCategory ?? "Khác";
        if (!grouped.containsKey(sub)) grouped[sub] = [];
        grouped[sub]!.add(r);
      }

      setState(() {
        recipesBySub = grouped;
      });
    } catch (e) {
      debugPrint("Lỗi lấy món ăn theo danh mục: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipesBySub.isEmpty
          ? const Center(child: Text("Không có món ăn nào"))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: recipesBySub.entries.map((entry) {
                final subCategory = entry.key;
                final recipes = entry.value;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: const Offset(0, -3), // hướng bóng lên trên
                        blurRadius: 8, // độ mờ
                        spreadRadius: 1, // độ lan rộng
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    title: Text(
                      subCategory,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: recipes.map((recipe) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(recipe.name),
                        subtitle: Text(
                          "Nguyên liệu: ${recipe.ingredients.length}",
                        ),
                        trailing: IconButton(
                          icon: Image.asset(
                            "assets/icons/cooking/cooking.png",
                            width: 28,
                            height: 28,
                          ),
                          onPressed: () async {
                            try {
                              final result = await RecipeService.addToKitchen(
                                recipe.id!,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${result.name} đã được thêm vào Nhà bếp!",
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Món ăn đã có trong Nhà bếp"),
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
