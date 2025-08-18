import 'package:da_food/Provider/category_provider.dart';
import 'package:da_food/Provider/tab_provider.dart';
import 'package:da_food/View/category_screen.dart';
import 'package:da_food/View/home_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
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
