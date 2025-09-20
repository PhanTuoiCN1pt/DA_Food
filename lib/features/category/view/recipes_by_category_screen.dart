import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/recipe_service.dart';
import '../view/recipe_detail_screen.dart';
import '../view_model/recipe_provider.dart';

class RecipesBySubCategoryScreen extends StatelessWidget {
  final String category;

  const RecipesBySubCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipesProvider(category)..loadRecipes(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<RecipesProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.recipesBySub.isEmpty) {
              return const Center(child: Text("Không có món ăn nào"));
            }

            return ListView(
              padding: const EdgeInsets.all(12),
              children: provider.recipesBySub.entries.map((entry) {
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
                        offset: const Offset(0, -3),
                        blurRadius: 8,
                        spreadRadius: 1,
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
            );
          },
        ),
      ),
    );
  }
}
