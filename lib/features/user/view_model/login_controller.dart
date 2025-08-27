import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/loader.dart';

class LoginController {
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    // 👉 Kiểm tra không để trống
    if (email.isEmpty || password.isEmpty) {
      Loaders.warningSnackBar(
        title: "Thiếu thông tin",
        message: "Vui lòng nhập đầy đủ email và mật khẩu!",
      );
      return; // Dừng lại, không gọi API
    }

    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.105:5000/api/users/login"),
        headers: {"Content-Type": "application/json"}, // quan trọng
        body: jsonEncode({'email': email, 'password': password}), // encode JSON
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveUserLogin(data);
        onSuccess(); // 👈 callback để chuyển màn hình
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Đăng nhập thành công!",
        );
      } else {}
    } catch (e) {
      Loaders.warningSnackBar(
        title: "Lỗi kết nối",
        message: "Không thể kết nối server: $e",
      );
    }
  }

  static Future<void> saveUserLogin(Map<String, dynamic> loginData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', loginData['token']);
    await prefs.setString('userId', loginData['user']['id']);
    print("BODY: ${prefs.getString('userId')}");
  }
}
