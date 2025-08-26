import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../helper/loader.dart';

class RegisterController {
  static Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.105:5000/api/users/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 201) {
        // ✅ Đăng ký thành công
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Đăng ký thành công!",
        );
        onSuccess(); // 👈 Quay lại màn login
      } else {
        // ❌ Đăng ký thất bại
        Loaders.errorSnackBar(
          title: "Lỗi ",
          message: "Vui lòng chọn 1 tài khoản email khác",
        );
      }
    } catch (e) {
      Loaders.warningSnackBar(
        title: "Lỗi kết nối",
        message: "Không thể kết nối server: $e",
      );
    }
  }
}
