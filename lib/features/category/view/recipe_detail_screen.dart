import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final ingredients = List<Map<String, dynamic>>.from(
      recipe["ingredients"] ?? [],
    );
    final instructions = List<String>.from(recipe["instructions"] ?? []);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          recipe["name"] ?? "Chi tiết món ăn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nguyên liệu
            const Text(
              "Nguyên liệu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...ingredients.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("- ${item["name"]} : ${item["quantity"]}"),
              ),
            ),

            const SizedBox(height: 20),

            // Hướng dẫn
            const Text(
              "Cách nấu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...instructions.asMap().entries.map((entry) {
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("- $step"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
