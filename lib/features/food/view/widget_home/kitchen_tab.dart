import 'package:da_food/features/food/model/food_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/recipe_service.dart';
import '../../../category/view/recipe_info_tab_screen.dart';

class KitchenTab extends StatefulWidget {
  const KitchenTab({super.key, required List<FoodItem> foods});

  @override
  State<KitchenTab> createState() => _KitchenTabState();
}

class _KitchenTabState extends State<KitchenTab> {
  late Future<List<Map<String, dynamic>>> _kitchenFuture;

  @override
  void initState() {
    super.initState();
    _loadKitchen();
  }

  void _loadKitchen() {
    _kitchenFuture = RecipeService.getKitchenRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: RecipeService.getKitchenRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Lỗi tải món ăn trong Nhà bếp"));
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
                leading: Image.asset(
                  "assets/icons/cooking/cook-book.png",
                  width: 35,
                  height: 35,
                ),
                title: Text(
                  recipe["name"] ?? "Không có tên",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Nguyên liệu: ${recipe["ingredients"]?.length ?? 0}",
                ),
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
                      await RecipeService.removeFromKitchen(recipe["_id"]);
                      setState(() {
                        _loadKitchen(); // reload danh sách
                      });
                      (context as Element).reassemble();
                    }
                    // Xóa món ăn khỏi Kitchen
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
