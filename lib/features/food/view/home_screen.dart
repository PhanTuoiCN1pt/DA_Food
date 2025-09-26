import 'package:da_food/features/food/view/widget_home/food_tab.dart';
import 'package:da_food/features/food/view/widget_home/home_header.dart';
import 'package:da_food/features/food/view/widget_home/kitchen_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/color_helper.dart';
import '../view_model/home_provider.dart';
import 'meal_suggestions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final labels = const ["Ngăn lạnh", "Ngăn đông", "Nhà bếp"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: labels.length, vsync: this);

    // load data khi mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().reloadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2D99AE),
                  Color(0xFFBCFEFE),
                ], // cặp màu gradient
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    HomeHeader(
                      tabController: _tabController,
                      labels: labels,
                      user: provider.user,
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.grey,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: provider.loading
                            ? const Center(child: CircularProgressIndicator())
                            : TabBarView(
                                controller: _tabController,
                                children: [
                                  FoodTab(
                                    locationLabel: "Ngăn lạnh",
                                    foods: provider.fridgeFoods,
                                    onReload: provider.loadFoods,
                                  ),
                                  FoodTab(
                                    locationLabel: "Ngăn đông",
                                    foods: provider.freezerFoods,
                                    onReload: provider.loadFoods,
                                  ),
                                  KitchenTab(
                                    onReload: provider.loadKitchen,
                                    recipes: provider.recipes,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),

                // Nút suggestMeal
                if (provider.user != null)
                  Positioned(
                    bottom: 70,
                    right: -30,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MealSuggestionsScreen(user: provider.user!),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/icons/icon_app/icon_app_no_text.png",
                        scale: 5,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // FAB add
          floatingActionButton: Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF004D40),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/category').then((_) {
                  provider.loadFoods();
                  provider.loadKitchen();
                });
              },
            ),
          ),
        );
      },
    );
  }
}
