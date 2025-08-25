import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/food/model/food_model.dart';

class FoodService {
  static const baseUrl =
      "http://192.168.0.105:5000/api/foods"; // Android Emulator

  static Future<FoodItem> addFood(FoodItem food) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(food.toJson()),
    );
    if (res.statusCode == 201) {
      return FoodItem.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to add food: ${res.body}");
    }
  }

  static Future<FoodItem> updateFood(FoodItem food) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${food.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(food.toJson()),
    );
    if (res.statusCode == 200) {
      return FoodItem.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to update food: ${res.body}");
    }
  }
}
