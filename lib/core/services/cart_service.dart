import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../connect/api_url.dart';

class CartService {
  static final String baseUrl = "$apiUrl/api/cart";

  /// Thêm food vào giỏ hàng
  static Future<List<dynamic>> addToCart(String foodName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final url = Uri.parse("$baseUrl/$userId/add");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"foodName": foodName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to add to cart: ${response.body}");
    }
  }

  /// Lấy giỏ hàng
  static Future<List<dynamic>> getCart(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final url = Uri.parse("$baseUrl/$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch cart: ${response.body}");
    }
  }

  /// Xóa nhiều item cùng lúc
  static Future<List<dynamic>> deleteCartItems(List<String> itemIds) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final url = Uri.parse("$baseUrl/$userId/delete-multiple");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"itemIds": itemIds}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to delete items: ${response.body}");
    }
  }

  /// Xóa toàn bộ giỏ hàng
  static Future<void> clearCart(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final url = Uri.parse("$baseUrl/$userId/clear");
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to clear cart: ${response.body}");
    }
  }

  /// Cập nhật trạng thái done của 1 item
  static Future<List<dynamic>> updateCartItemDone(
    String itemId,
    bool done,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final url = Uri.parse("$baseUrl/$userId/update/$itemId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"done": done}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update cart item: ${response.body}");
    }
  }
}
