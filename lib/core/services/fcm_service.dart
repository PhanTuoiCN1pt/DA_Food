import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../connect/api_url.dart';

class FcmService {
  static final String baseUrl = "$apiUrl/api/users/save-token";

  static Future<void> saveToken(String userId, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "fcmToken": token}),
    );

    if (response.statusCode == 200) {
      print("FCM Token đã lưu thành công");
    } else {
      print("Lỗi khi lưu FCM token: ${response.body}");
    }
  }
}
