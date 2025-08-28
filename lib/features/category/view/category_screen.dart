import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/category_data.dart';
import 'food_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.watch<CategoryProvider>().selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thể loại",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                        Image.asset(
                          item["icon"], // 👈 đổi từ IconData sang đường dẫn
                          width: 40,
                          height: 40,
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Divider(height: 25, thickness: 1, color: Colors.black),
            ),

            // Grid danh mục con
            if (selectedCategory != null &&
                subCategories.containsKey(selectedCategory)) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  selectedCategory.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ).copyWith(bottom: 50),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.75,
                ),
                itemCount: subCategories[selectedCategory]!.length + 1,
                itemBuilder: (context, index) {
                  if (index == subCategories[selectedCategory]!.length) {
                    // Ô cuối cùng = thêm food mới
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // 👉 xử lý thêm food mới
                        print("Thêm food mới trong $selectedCategory");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 32, color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  final subItem = subCategories[selectedCategory]![index];
                  return Material(
                    color: Colors.transparent, // giữ trong suốt
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 650,
                            ),
                            pageBuilder: (_, animation, __) => FoodDetailScreen(
                              category: selectedCategory,
                              subCategory: subItem["label"],
                            ),
                            transitionsBuilder: (_, animation, __, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

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
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(subItem["icon"], width: 40, height: 40),
                            const SizedBox(height: 6),
                            Text(
                              subItem["label"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
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
