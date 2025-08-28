import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/food/model/user_model.dart';

class UserServer {
  static const String baseUrl = "http://localhost:5000/api/users";

  // Lấy tất cả user
  static Future<List<UserModel>> fetchAllUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  // Lấy 1 user theo id
  static Future<UserModel> fetchUserById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load user");
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
      throw Exception("Failed to update user");
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
