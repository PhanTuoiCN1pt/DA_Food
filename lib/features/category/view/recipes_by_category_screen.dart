import 'package:da_food/features/category/view/recipe_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/services/recipe_service.dart';

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
      final data = await RecipeService.fetchRecipesByCategory(widget.category);
      setState(() {
        recipes = data;
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
          : recipes.isEmpty
          ? const Center(child: Text("Không có món ăn nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      recipe["name"] ?? "Không có tên",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    trailing: IconButton(
                      onPressed: () async {
                        try {
                          final result = await RecipeService.addToKitchen(
                            recipe["_id"],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${result["recipe"]["name"]} đã được thêm vào Nhà bếp!",
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
                      icon: Image.asset(
                        "assets/icons/cooking/cooking.png",
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
