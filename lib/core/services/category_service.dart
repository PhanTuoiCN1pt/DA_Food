import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../connect/api_url.dart';
import '../../features/food/model/category_model.dart';

class CategoryService {
  final String baseUrl = "$apiUrl/api/categories"; // đổi theo API thật

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Category.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
