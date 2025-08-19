import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:da_food/features/food/view_model/food_provider.dart';
import 'package:da_food/features/food/view_model/foods_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/category/view/category_screen.dart';
import 'features/food/view/home_screen.dart';
import 'features/food/view_model/tab_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => FoodsProvider()),
      ],
      child: DevicePreview(enabled: true, builder: (context) => MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/category': (context) => CategoryScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
