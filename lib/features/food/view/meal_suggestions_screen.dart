import 'package:flutter/material.dart';

import '../../../core/services/food_server.dart';
import '../../../features/food/model/recipe_model.dart';
import '../model/user_model.dart';

class MealSuggestionsScreen extends StatefulWidget {
  final UserModel user;

  const MealSuggestionsScreen({super.key, required this.user});

  @override
  State<MealSuggestionsScreen> createState() => _MealSuggestionsScreenState();
}

class _MealSuggestionsScreenState extends State<MealSuggestionsScreen> {
  late Future<List<RecipeModel>> _suggestionsFuture;

  @override
  void initState() {
    super.initState();
    _suggestionsFuture = FoodService.getMealSuggestions(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gợi ý món ăn")),
      body: FutureBuilder<List<RecipeModel>>(
        future: _suggestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Lỗi khi lấy dữ liệu: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Không tìm thấy món phù hợp với thực phẩm hiện có."),
            );
          }

          final suggestions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: suggestions.length,
            itemBuilder: (_, index) {
              final recipe = suggestions[index];
              return Card(
                elevation: 2,
                child: ExpansionTile(
                  title: Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nguyên liệu:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...recipe.ingredients.map(
                            (i) => Text("- ${i.name}: ${i.quantity}"),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Hướng dẫn:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...recipe.instructions.map((step) => Text("- $step")),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
