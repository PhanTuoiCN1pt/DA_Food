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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> labels = const ["Tủ lạnh", "Tủ đông", "Nhà bếp"];
  final List<IconData> icons = const [
    Icons.ac_unit,
    Icons.icecream,
    Icons.kitchen,
  ];

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    return DefaultTabController(
      length: labels.length,
      initialIndex: tabProvider.currentIndex,
      child: Scaffold(
        backgroundColor: Colors.purple,
        body: Column(
          children: [
            /// Header thay AppBar
            Container(
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
                        children: [
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
                    dividerColor: Colors
                        .transparent, // 👈 xoá line mỏng bên dưới TabBar (quan trọng)
                    tabs: List.generate(labels.length, (index) {
                      final isSelected = tabProvider.currentIndex == index;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
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
            ),

            /// Body bo góc trên
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: TColors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Consumer<FoodsProvider>(
                  builder: (context, foodsProvider, child) {
                    final foods = foodsProvider.foods;

                    if (foods.isEmpty) {
                      return const Center(child: Text("Chưa có thực phẩm nào"));
                    }

                    // nhóm theo category
                    final Map<String, List<FoodItem>> grouped = {};
                    for (var f in foods) {
                      grouped.putIfAbsent(f.category, () => []).add(f);
                    }

                    return TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: labels.map((locationLabel) {
                        // lọc food theo location (tủ lạnh, tủ đông, nhà bếp)
                        final filteredFoods = foods
                            .where((f) => f.location == locationLabel)
                            .toList();

                        if (filteredFoods.isEmpty) {
                          return Center(
                            child: Text(
                              "Chưa có thực phẩm trong $locationLabel",
                            ),
                          );
                        }

                        // nhóm tiếp theo category
                        final Map<String, List<FoodItem>> groupedByCategory =
                            {};
                        for (var f in filteredFoods) {
                          groupedByCategory
                              .putIfAbsent(f.category, () => [])
                              .add(f);
                        }

                        return ListView(
                          children: groupedByCategory.entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // tiêu đề category
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
                                // danh sách item trong category
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: entry.value.map((food) {
                                      final daysLeft = food.expiryDate
                                          .difference(DateTime.now())
                                          .inDays;

                                      return GestureDetector(
                                        onTap: () {
                                          // Chuyển sang FoodDetailScreen với category và subCategory
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  FoodEditScreen(food: food),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "D-$daysLeft",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Image.asset(
                                                FoodIconHelper.getIconByName(
                                                  food.name,
                                                ),
                                                width: 40,
                                                height: 40,
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Text(
                                                    food.name,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                  },
                ),
              ),
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
              Navigator.pushNamed(context, '/category');
            },
          ),
        ),
      ),
    );
  }
}
