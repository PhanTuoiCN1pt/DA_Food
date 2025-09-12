import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:da_food/features/food/view_model/food_provider.dart';
import 'package:da_food/features/food/view_model/recipe_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'features/category/view/category_screen.dart';
import 'features/food/view/home_screen.dart';
import 'features/food/view_model/tab_provider.dart';
import 'features/user/view/auth_screen.dart';
import 'features/user/view/widget/constants.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
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
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(
            vertical: defpaultPadding * 1.2,
            horizontal: defpaultPadding,
          ),
        ),
      ),
      home: AuthScreen(),
      routes: {
        '/category': (context) => CategoryScreen(),
        '/home': (context) => HomeScreen(),
        '/auth': (context) => AuthScreen(),
      },
    );
  }
}

// import 'package:da_food/features/user/view/home_test.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await NotificationService().initNotification();
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(MyApp());
// }
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print(message.notification!.title.toString());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Flutter",
//       theme: ThemeData(primaryColor: Colors.blue),
//       home: HomeTest(),
//     );
//   }
// }
