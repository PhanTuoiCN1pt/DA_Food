import 'package:flutter/material.dart';

class RecipeInfoTabScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeInfoTabScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Ép kiểu ingredients sang List<Map>
    final ingredients = List<Map<String, dynamic>>.from(
      recipe["ingredients"] ?? [],
    );
    final instructions = List<String>.from(recipe["instructions"] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe["name"] ?? "Chi tiết món ăn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        child: ListView(
          children: [
            const Text(
              "Nguyên liệu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...ingredients.map((ing) {
              final name = ing["name"] ?? "Không rõ";
              final quantity = ing["quantity"] ?? "";
              return Text(
                "- $name ${quantity.isNotEmpty ? "($quantity)" : ""}",
                style: TextStyle(fontSize: 16),
              );
            }),

            const SizedBox(height: 20),

            const Text(
              "Cách nấu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...instructions.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("${e.key + 1}. ${e.value}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
