import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:da_food/features/food/view_model/food_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'core/services/notification_service.dart';
import 'features/category/view/category_screen.dart';
import 'features/food/view/home_screen.dart';
import 'features/food/view_model/tab_provider.dart';
import 'features/user/view/auth_screen.dart';
import 'features/user/view/splash_screen.dart';
import 'features/user/view/widget/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Khởi tạo NotificationService
  final notificationService = NotificationService();
  await notificationService.initNotification();

  // 🔹 Lắng nghe FCM khi app foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notification.title,
        body: notification.body,
      );
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        // ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      // child: DevicePreview(enabled: true, builder: (context) => MyApp()),
      child: MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white38,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.white),
          contentPadding: const EdgeInsets.symmetric(
            vertical: defpaultPadding * 1.2,
            horizontal: defpaultPadding,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/category': (context) => CategoryScreen(),
        '/home': (context) => HomeScreen(),
        '/auth': (context) => AuthScreen(),
      },
    );
  }
}
