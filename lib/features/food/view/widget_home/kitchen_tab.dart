import 'package:da_food/features/food/model/food_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/recipe_server.dart';
import '../../../category/view/recipe_info_tab_screen.dart';

class KitchenTab extends StatelessWidget {
  const KitchenTab({super.key, required List<FoodItem> foods});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: RecipeService.getKitchenRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("❌ Lỗi tải món ăn trong Nhà bếp"));
        }
        final recipes = snapshot.data ?? [];
        if (recipes.isEmpty) {
          return const Center(child: Text("Chưa có món ăn trong Nhà bếp"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: ListTile(
                leading: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.orange,
                ),
                title: Text(
                  recipe["name"] ?? "Không có tên",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Nguyên liệu: ${recipe["ingredients"]?.length ?? 0}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeInfoTabScreen(recipe: recipe),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
