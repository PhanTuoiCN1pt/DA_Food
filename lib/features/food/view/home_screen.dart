import 'package:da_food/features/food/view/widget/rounded_underline_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
        appBar: AppBar(
          title: Text(
            "Food AI",
            style: GoogleFonts.oswald(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
          bottom: TabBar(
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
              insets: EdgeInsets.symmetric(horizontal: 18.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
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
        ),
        body: Consumer<FoodsProvider>(
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

            return ListView(
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${entry.key} (${entry.value.length})",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value.map((food) {
                        return Container(
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.fastfood,
                                size: 40,
                              ), // thay bằng ảnh
                              const SizedBox(height: 4),
                              Text(food.name, textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),

        floatingActionButton: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // vẫn tròn
            gradient: const LinearGradient(
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
