class RecipeModel {
  String? id;
  String name;
  List<Ingredient> ingredients;
  List<String> instructions;
  String category;
  DateTime? createdAt;

  RecipeModel({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.category,
    this.createdAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id,
      "name": name,
      "category": category,
      "ingredients": ingredients.map((e) => e.toJson()).toList(),
      "instructions": instructions,
      "createdAt": createdAt?.toIso8601String(),
    };
  }
}

class Ingredient {
  String? id;
  String name;
  String quantity;

  Ingredient({this.id, required this.name, required this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) "_id": id, "name": name, "quantity": quantity};
  }
}
