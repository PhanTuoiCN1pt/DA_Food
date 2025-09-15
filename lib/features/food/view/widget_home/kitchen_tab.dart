import 'package:flutter/material.dart';

import '../../../../core/services/recipe_service.dart';
import '../../../category/view/recipe_info_tab_screen.dart';
import '../../model/recipe_model.dart';

class KitchenTab extends StatelessWidget {
  final List<RecipeModel> recipes;
  final VoidCallback? onReload;

  const KitchenTab({super.key, required this.recipes, this.onReload});

  @override
  Widget build(BuildContext context) {
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
            title: Text(
              recipe.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Nguyên liệu: ${recipe.ingredients?.length ?? 0}"),
            trailing: IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Xác nhận"),
                    content: const Text("Bạn có chắc muốn xóa món này?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          "Xóa",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await RecipeService.removeFromKitchen(recipe.id!);
                  if (onReload != null) onReload!();
                }
              },
              icon: Image.asset(
                "assets/icons/icon_app/food-waste.png",
                width: 35,
                height: 35,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeInfoTabScreen(recipe: recipe.toJson()),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
