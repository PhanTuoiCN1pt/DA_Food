import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../connect/api_url.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool expiryReminder = true;
  bool dailyReminder = true;

  // notifyTimeApi: lưu dạng "HH:mm" gửi lên server
  String? notifyTimeApi;
  // notifyTimeDisplay: hiển thị cho user (ví dụ "9:30 AM" hoặc "21:30")
  String notifyTimeDisplay = "Chưa chọn giờ";

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
  }

  // Gọi API lưu notifyTime (apiTime: "HH:mm", display: hiển thị)
  Future<void> setNotifyTime(String apiTime, String display) async {
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User chưa đăng nhập")));
      return;
    }

    final url = Uri.parse("$apiUrl/api/notify/set-time");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "notifyTime": apiTime, // gửi định dạng HH:mm
        }),
      );

      // parse response nếu có
      dynamic body;
      try {
        body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      } catch (_) {
        body = response.body;
      }

      if (response.statusCode == 200) {
        setState(() {
          notifyTimeApi = apiTime;
          notifyTimeDisplay = display;
        });

        final msg =
            (body is Map && (body['message'] ?? body['success']) != null)
            ? (body['message'] ?? "Đã lưu")
            : "Đã lưu thời gian thông báo";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ $msg")));
      } else {
        final err = (body is Map)
            ? (body['error'] ?? body['message'] ?? body.toString())
            : body ?? response.body;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Lỗi: $err")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Lỗi kết nối: ${e.toString()}")));
    }
  }

  // Mở TimePicker, format cho API (24h HH:mm) + hiển thị local
  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      initialEntryMode: TimePickerEntryMode.input, // 👈 chỉ nhập giờ phút
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: true), // 👈 24h, không AM/PM
          child: child!,
        );
      },
    );

    if (picked == null) return;

    // Format API: 24h HH:mm
    final apiHour = picked.hour.toString().padLeft(2, '0');
    final apiMinute = picked.minute.toString().padLeft(2, '0');
    final apiFormat = "$apiHour:$apiMinute";

    // Format hiển thị: luôn 24h
    final display = "${apiHour}:${apiMinute}";

    await setNotifyTime(apiFormat, display);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông báo")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Lời nhắc ngày hết hạn"),
            value: expiryReminder,
            onChanged: (val) {
              setState(() => expiryReminder = val);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text("Nhắc nhở hằng ngày về thực phẩm gần hết hạn"),
            value: dailyReminder,
            onChanged: (val) {
              setState(() => dailyReminder = val);
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text("Ngày thông báo"),
            trailing: const Text("Ngày hết hạn"),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text("Thời gian thông báo"),
            trailing: Text(notifyTimeDisplay),
            onTap: _pickTime,
          ),
        ],
      ),
    );
  }
}
