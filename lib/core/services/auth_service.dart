import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/loader.dart';
import '../../connect/api_url.dart';

class AuthService {
  static final String baseUrl = "$apiUrl/api/auths";

  /// -------------------- LOGIN --------------------
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required String fcmToken,

    required VoidCallback onSuccess,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      Loaders.warningSnackBar(
        title: "Thiếu thông tin",
        message: "Vui lòng nhập đầy đủ email và mật khẩu!",
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
          'fcmToken': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveUserLogin(data, fcmToken);
        onSuccess();

        Loaders.successSnackBar(
          title: "Thành công",
          message: "Đăng nhập thành công!",
        );
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message: "Sai email hoặc mật khẩu!",
        );
      }
    } catch (e) {
      Loaders.warningSnackBar(
        title: "Lỗi kết nối",
        message: "Không thể kết nối server: $e",
      );
    }
  }

  /// -------------------- LOGOUT --------------------
  static Future<void> logout(
    BuildContext context, {
    VoidCallback? onSuccess,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      // 🔹 Gọi API logout để server xoá fcmToken trong DB
      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // Xoá tất cả dữ liệu login (token, userId, fcmToken) ở local
        await prefs.remove("token");
        await prefs.remove("userId");
        await prefs.remove("fcmToken");

        debugPrint("✅ Đã xoá token, userId và fcmToken khi logout");

        Loaders.successSnackBar(
          title: "Đăng xuất",
          message: "Bạn đã đăng xuất thành công!",
        );

        if (onSuccess != null) onSuccess();
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message: "Không thể logout: ${response.body}",
        );
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: "Lỗi",
        message: "Không thể kết nối server: $e",
      );
    }
  }

  /// -------------------- REGISTER --------------------
  static Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String? fcmToken,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "fcmToken": fcmToken,
        }),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 201) {
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Đăng ký thành công!",
        );
        onSuccess();
      } else {
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

  /// -------------------- CHANGE PASSWORD --------------------
  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.post(
        Uri.parse("$baseUrl/change-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ Exception changePassword: $e");
      return false;
    }
  }

  /// -------------------- FORGOT PASSWORD --------------------
  static Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ Exception forgotPassword: $e");
      return false;
    }
  }

  /// -------------------- RESET PASSWORD --------------------
  static Future<bool> resetPassword(String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password/$otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"newPassword": newPassword}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ Exception resetPassword: $e");
      return false;
    }
  }

  /// -------------------- SAVE USER DATA --------------------
  static Future<void> _saveUserLogin(
    Map<String, dynamic> loginData,
    String fcmToken,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', loginData['token']);
    await prefs.setString('userId', loginData['user']['id']);
    await prefs.setString('fcmToken', fcmToken);
    debugPrint("USER ID SAVED: ${prefs.getString('userId')}");
    debugPrint("FCM TOKEN SAVED: ${prefs.getString('fcmToken')}");
  }
}
