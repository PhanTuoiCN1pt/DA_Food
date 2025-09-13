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
    required String fcmToken, // 👈 Thêm fcmToken khi login

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
          'fcmToken': fcmToken, // 👈 gửi token lên server
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
          "fcmToken": fcmToken, // 👈 gửi lên
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

  /// -------------------- FORGOT PASSWORD --------------------
  static Future<void> forgotPassword({
    required BuildContext context,
    required String email,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Đã gửi link reset mật khẩu tới email của bạn!",
        );
        onSuccess();
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message: "Email không tồn tại!",
        );
      }
    } catch (e) {
      Loaders.warningSnackBar(
        title: "Lỗi kết nối",
        message: "Không thể kết nối server: $e",
      );
    }
  }

  /// -------------------- RESET PASSWORD --------------------
  static Future<void> resetPassword({
    required BuildContext context,
    required String token,
    required String newPassword,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token, "password": newPassword}),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Mật khẩu đã được thay đổi!",
        );
        onSuccess();
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message: "Token không hợp lệ hoặc đã hết hạn!",
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
  static Future<void> changePassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
    required VoidCallback onSuccess,
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
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        Loaders.successSnackBar(
          title: "Thành công",
          message: "Đổi mật khẩu thành công!",
        );
        onSuccess();
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message: "Mật khẩu hiện tại không đúng!",
        );
      }
    } catch (e) {
      Loaders.warningSnackBar(
        title: "Lỗi kết nối",
        message: "Không thể kết nối server: $e",
      );
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
