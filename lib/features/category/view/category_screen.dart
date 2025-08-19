import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'food_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"icon": Icons.local_grocery_store, "label": "Trái cây"},
    {"icon": Icons.eco, "label": "Rau"},
    {"icon": Icons.set_meal, "label": "Thịt"},
    {"icon": Icons.set_meal_outlined, "label": "Thủy sản"},
    {"icon": Icons.icecream, "label": "Chế phẩm từ sữa"},
    {"icon": Icons.restaurant, "label": "Món ăn"},
    {"icon": Icons.local_drink, "label": "Đồ uống"},
    {"icon": Icons.wine_bar, "label": "Rượu"},
    {"icon": Icons.soup_kitchen, "label": "Nước sốt"},
    {"icon": Icons.spa, "label": "Gia vị"},
    {"icon": Icons.bakery_dining, "label": "Bánh mì"},
    {"icon": Icons.cake, "label": "Tráng miệng"},
    {"icon": Icons.nature, "label": "Quả hạch"},
    {"icon": Icons.rice_bowl, "label": "Ngũ cốc"},
    {"icon": Icons.more_horiz, "label": "Vân vân"},
  ];

  final Map<String, List<Map<String, dynamic>>> subCategories = {
    "Trái cây": [
      {"icon": Icons.apple, "label": "Táo"},
      {"icon": Icons.energy_savings_leaf, "label": "Chuối"},
      {"icon": Icons.emoji_food_beverage, "label": "Cam"},
    ],
    "Rau": [
      {"icon": Icons.eco, "label": "Rau muống"},
      {"icon": Icons.eco, "label": "Bắp cải"},
    ],
    "Thịt": [
      {"icon": Icons.set_meal, "label": "Thịt bò"},
      {"icon": Icons.set_meal, "label": "Thịt gà"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.watch<CategoryProvider>().selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thể loại"),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 8),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid danh mục chính
            GridView.builder(
              shrinkWrap: true, // 👈 không chiếm hết màn
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.75,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final item = categories[index];
                final isSelected = item["label"] == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    context.read<CategoryProvider>().selectCategory(
                      item["label"],
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Colors.purple, Colors.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null, // khi chưa chọn thì không có gradient
                      color: isSelected
                          ? null
                          : Colors
                                .transparent, // giữ nền trong suốt khi chưa chọn
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : Colors.transparent, // viền khi chưa chọn
                        width: 1,
                      ),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item["icon"],
                          size: 40,
                          color: isSelected ? Colors.white : Colors.orange,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["label"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Grid danh mục con
            if (selectedCategory != null &&
                subCategories.containsKey(selectedCategory)) ...[
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Danh mục con",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.75,
                ),
                itemCount: subCategories[selectedCategory]!.length,
                itemBuilder: (context, index) {
                  final subItem = subCategories[selectedCategory]![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(
                            milliseconds: 400,
                          ), // thời gian hiệu ứng
                          pageBuilder: (_, animation, secondaryAnimation) =>
                              FoodDetailScreen(
                                category: selectedCategory,
                                subCategory: subItem["label"],
                              ),
                          transitionsBuilder: (_, animation, __, child) {
                            const begin = Offset(1.0, 0.0); // bắt đầu từ phải
                            const end = Offset.zero; // kết thúc ở giữa
                            const curve = Curves.easeInOut; // hiệu ứng mượt

                            final tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(subItem["icon"], size: 40, color: Colors.blue),
                        const SizedBox(height: 6),
                        Text(
                          subItem["label"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
