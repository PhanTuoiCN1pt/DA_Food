import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String baseUrl = "http://192.168.0.103:5000/api/cart";

  /// Thêm food vào giỏ hàng (chỉ lưu tên)
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
      return jsonDecode(response.body); // trả về danh sách cart
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

  /// Xóa 1 item
  static Future<List<dynamic>> removeFromCart(
    String userId,
    String foodName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null || userId.isEmpty) {
      throw Exception("Bạn chưa đăng nhập");
    }

    final url = Uri.parse("$baseUrl/$userId/remove/$foodName");
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to remove from cart: ${response.body}");
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
}
