import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_food/features/category/view/food_edit_screen.dart';
import 'package:da_food/features/food/view/widget/rounded_underline_indicator.dart';
import 'package:da_food/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../helper/food_icon_helper.dart';
import '../model/food_model.dart';
import '../view_model/foods_provider.dart';
import '../view_model/tab_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> labels = const ["Tủ lạnh", "Tủ đông", "Nhà bếp"];
  final List<IconData> icons = const [
    Icons.ac_unit,
    Icons.icecream,
    Icons.kitchen,
  ];

  @override
  void initState() {
    super.initState();
    // Load foods lần đầu
    Future.microtask(
      () => Provider.of<FoodsProvider>(context, listen: false).fetchFoods(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    return DefaultTabController(
      length: labels.length,
      initialIndex: tabProvider.currentIndex,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

          tabController.animation?.addListener(() {
            final newIndex = tabController.animation!.value.round();
            if (tabProvider.currentIndex != newIndex) {
              tabProvider.setTab(newIndex);
            }
          });

          return Scaffold(
            backgroundColor: Colors.purple,
            body: Stack(
              children: [
                Column(
                  children: [
                    /// Header
                    _buildHeader(tabProvider),

                    /// Body
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.grey,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Consumer<FoodsProvider>(
                          builder: (context, foodsProvider, child) {
                            if (foodsProvider.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final foods = foodsProvider.foods;
                            if (foods.isEmpty) {
                              return const Center(
                                child: Text("Chưa có thực phẩm nào"),
                              );
                            }

                            return _buildTabBarView(foods);
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                /// Overlay loading (mờ cả màn hình)
                Consumer<FoodsProvider>(
                  builder: (context, foodsProvider, child) {
                    if (!foodsProvider.isLoading) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),

            /// Floating button
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
                    // 👉 Reload khi pop về
                    Provider.of<FoodsProvider>(
                      context,
                      listen: false,
                    ).fetchFoods();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// Header với TabBar
  Widget _buildHeader(TabProvider tabProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          /// Title + actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Food AI",
                style: GoogleFonts.oswald(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ],
          ),

          /// TabBar
          TabBar(
            onTap: (index) => tabProvider.setTab(index),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            indicator: const RoundedUnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: Colors.white),
              radius: 6.0,
              insets: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: List.generate(labels.length, (index) {
              final isSelected = tabProvider.currentIndex == index;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isSelected
                    ? Text(
                        labels[index],
                        key: ValueKey("text_$index"),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(
                        icons[index],
                        key: ValueKey("icon_$index"),
                        color: Colors.white,
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// TabBarView hiển thị danh sách
  Widget _buildTabBarView(List<FoodItem> foods) {
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: labels.map((locationLabel) {
        final filteredFoods = foods
            .where((f) => f.location == locationLabel)
            .toList();

        if (filteredFoods.isEmpty) {
          return Center(child: Text("Chưa có thực phẩm trong $locationLabel"));
        }

        // Nhóm theo category
        final Map<String, List<FoodItem>> groupedByCategory = {};
        for (var f in filteredFoods) {
          groupedByCategory.putIfAbsent(f.category, () => []).add(f);
        }

        return ListView(
          children: groupedByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    "${entry.key} (${entry.value.length})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 20,
                    children: entry.value.map((food) {
                      final daysLeft = food.expiryDate
                          .difference(DateTime.now())
                          .inDays;

                      return GestureDetector(
                        onTap: () {
                          print('${food.id}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodEditScreen(food: food),
                            ),
                          ).then((_) {
                            // reload khi back từ FoodEditScreen
                            Provider.of<FoodsProvider>(
                              context,
                              listen: false,
                            ).fetchFoods();
                          });
                        },
                        child: _buildFoodItem(food, daysLeft),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  /// Widget item thực phẩm
  Widget _buildFoodItem(FoodItem food, int daysLeft) {
    return Container(
      width: 87,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.all(4),
                  child: Transform.translate(
                    offset: Offset(-10, -10),
                    child: Container(
                      padding: EdgeInsets.only(right: 4, left: 4),
                      decoration: BoxDecoration(
                        color: TColors.grey,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        "D-$daysLeft",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(10, -1),
                child: Container(
                  width: 30,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "x${food.quantity}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Transform.translate(
            offset: Offset(0, -10),
            child: Image.asset(
              FoodIconHelper.getIconByName(food.name),
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.maxFinite,
            height: 45,
            decoration: BoxDecoration(
              color: TColors.grey,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Center(
                child: AutoSizeText(
                  food.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 8,
                  maxFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  wrapWords: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
