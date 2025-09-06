import 'package:da_food/features/food/view/widget_home/food_tab.dart';
import 'package:da_food/features/food/view/widget_home/home_header.dart';
import 'package:da_food/features/food/view/widget_home/kitchen_tab.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/food_server.dart';
import '../../../core/services/user_server.dart';
import '../../../helper/color_helper.dart';
import '../../food/model/food_model.dart';
import '../model/user_model.dart';
import 'meal_suggestions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FoodItem> _kitchenFoods = [];
  List<FoodItem> _fridgeFoods = [];
  List<FoodItem> _freezerFoods = [];
  bool _loading = true;
  UserModel? user;

  final labels = const ["Tủ lạnh", "Tủ đông", "Nhà bếp"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: labels.length, vsync: this);
    loadUser();
    loadFoods();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";
    if (userId.isNotEmpty) {
      try {
        final fetchedUser = await UserServer.fetchUserById(userId);
        setState(() => user = fetchedUser);
      } catch (e) {
        debugPrint("Error fetching user: $e");
      }
    }
  }

  Future<void> loadFoods() async {
    try {
      final foods = await FoodService.fetchFoods();
      setState(() {
        _fridgeFoods = foods.where((f) => f.location == "Tủ lạnh").toList();
        _freezerFoods = foods.where((f) => f.location == "Tủ đông").toList();
        _kitchenFoods = foods.where((f) => f.location == "Nhà bếp").toList();
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Lỗi load foods: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Stack(
        children: [
          Column(
            children: [
              // 🔹 Header chung
              HomeHeader(
                tabController: _tabController,
                username: user?.name ?? "Đang tải...",
                labels: labels,
              ),

              // 🔹 Nội dung
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.grey,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            FoodTab(
                              locationLabel: "Tủ lạnh",
                              foods: _fridgeFoods,
                              onReload: loadFoods,
                            ),
                            FoodTab(
                              locationLabel: "Tủ đông",
                              foods: _freezerFoods,
                              onReload: loadFoods,
                            ),
                            KitchenTab(foods: _kitchenFoods),
                          ],
                        ),
                ),
              ),
            ],
          ),

          // 🔹 Nút suggestMeal nổi trên màn hình
          Positioned(
            bottom: 80,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealSuggestionsScreen(user: user!),
                    ),
                  );
                },
                icon: Image.asset(
                  "assets/icons/cooking/chef.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),

      // 🔹 Nút add mặc định
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pushNamed(context, '/category').then((_) {
              loadFoods(); // reload sau khi pop
            });
          },
        ),
      ),
    );
  }
}
