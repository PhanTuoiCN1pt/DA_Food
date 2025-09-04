import 'dart:convert';

import 'package:http/http.dart' as http;

class FcmService {
  static const String baseUrl =
      "http://192.168.0.103:5000/api/users/save-token";

  static Future<void> saveToken(String userId, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "fcmToken": token}),
    );

    if (response.statusCode == 200) {
      print("FCM Token đã lưu thành công ✅");
    } else {
      print("Lỗi khi lưu FCM token: ${response.body}");
    }
  }
}
