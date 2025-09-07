import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/food/model/user_model.dart';

class UserServer {
  static const String baseUrl = "http://192.168.0.103:5000/api/users";

  // Lấy tất cả user
  static Future<List<UserModel>> fetchAllUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception("Lỗi tải lên người dùng");
    }
  }

  // Lấy 1 user theo id
  static Future<UserModel> fetchUserById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Lỗi hiển thị người dùng");
    }
  }

  // Cập nhật user
  static Future<UserModel> updateUser(String id, UserModel user) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Lỗi cập nhật người dùng");
    }
  }

  // Xóa user
  static Future<bool> deleteUser(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
