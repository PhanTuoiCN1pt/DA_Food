import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/food_model.dart';

class FoodApi {
  static const baseUrl = "http://192.168.0.105:5000/api/foods";
  // Nếu chạy thật device: thay bằng IP máy thật (vd: http://192.168.1.5:5000)

  static Future<bool> addFood(FoodItem food) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": food.id,
          "category": food.category,
          "name": food.name,
          "quantity": food.quantity,
          "location": food.location,
          "subLocation": food.subLocation,
          "registerDate": food.registerDate.toIso8601String(),
          "expiryDate": food.expiryDate.toIso8601String(),
          "note": food.note,
        }),
      );

      if (response.statusCode == 201) {
        print("✅ Added to API: ${response.body}");
        return true;
      } else {
        print("❌ API error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return false;
    }
  }
}
