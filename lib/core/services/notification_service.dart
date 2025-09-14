import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../connect/api_url.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily notification channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    print("🔔 Now: ${tz.TZDateTime.now(tz.local)}");
    print("🔔 Scheduled: $scheduleDate");

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleNotificationAfter10s({
    int id = 1,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Thời gian sau 10 giây
    final scheduledDate = now.add(const Duration(seconds: 10));

    print("🔔 Now: $now");
    print("🔔 Scheduled: $scheduledDate");

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null, // chỉ chạy 1 lần
    );
  }

  Future<void> cancelAllNotification() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> setNotifyTime(String userId, String notifyTime) async {
    final url = Uri.parse("$apiUrl/api/notify/set-time"); // Android emulator
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "notifyTime": notifyTime, // ví dụ "23:30"
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Notify time set: ${response.body}");
    } else {
      print("❌ Error: ${response.body}");
    }
  }
}
