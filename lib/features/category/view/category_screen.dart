import 'package:da_food/features/category/view/recipes_by_category_screen.dart';
import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/category_service.dart';
import '../../../core/services/recipe_service.dart';
import '../../food/model/category_model.dart';
import 'add_food_screen.dart';
import 'food_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> mealCategories = []; // sub của "Món ăn"
  bool isLoadingMeals = false;

  List<Category> allCategories = []; // toàn bộ category từ API
  List<Map<String, dynamic>> apiSubCategories = []; // sub của category khác
  bool isLoadingSub = false;

  /// Load subCategory của "Món ăn" (RecipeService)
  Future<void> loadMealCategories() async {
    setState(() => isLoadingMeals = true);
    try {
      final data = await RecipeService.fetchMealCategories();
      setState(() {
        mealCategories = data;
      });
    } catch (e) {
      debugPrint("Lỗi lấy danh mục món ăn: $e");
    } finally {
      setState(() => isLoadingMeals = false);
    }
  }

  /// Load toàn bộ category từ API backend
  Future<void> loadCategories() async {
    try {
      final data = await CategoryService().fetchCategories();
      setState(() {
        allCategories = data;
      });
    } catch (e) {
      debugPrint("Lỗi load categories: $e");
    }
  }

  /// Load subCategories theo categoryId
  Future<void> loadSubCategories(String categoryId) async {
    setState(() => isLoadingSub = true);
    try {
      if (allCategories.isEmpty) {
        await loadCategories();
      }
      final selected = allCategories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => Category(id: "", icon: "", label: "", subCategories: []),
      );
      setState(() {
        apiSubCategories = selected.subCategories
            .map((e) => {"icon": e.icon, "label": e.label, "_id": e.id})
            .toList();
      });
    } catch (e) {
      debugPrint("Lỗi load subCategories: $e");
    } finally {
      setState(() => isLoadingSub = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories(); // load toàn bộ category khi mở screen
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.watch<CategoryProvider>().selectedCategory;

    // Nếu chọn "Món ăn" thì load từ API RecipeService
    if (selectedCategory == "Món ăn" &&
        mealCategories.isEmpty &&
        !isLoadingMeals) {
      loadMealCategories();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.75,
              ),
              itemCount: allCategories.length,
              itemBuilder: (context, index) {
                final item = allCategories[index];
                final isSelected = item.label == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    context.read<CategoryProvider>().selectCategory(item.label);

                    // Nếu khác "Món ăn" thì load subCategories từ API
                    if (item.label != "Món ăn") {
                      loadSubCategories(item.id);
                    }
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
                          : null,
                      color: isSelected ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(item.icon, width: 40, height: 40),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
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

            // Nếu chọn category "Món ăn" thì load từ API RecipeService
            if (selectedCategory == "Món ăn") ...[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: const Text(
                  "Món ăn",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (isLoadingMeals)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ).copyWith(bottom: 50),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: mealCategories.length + 1, // +1 để thêm ô dấu cộng
                  itemBuilder: (context, index) {
                    if (index == mealCategories.length) {
                      return InkWell(
                        onTap: () {
                          debugPrint("👉 Thêm món ăn mới");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }

                    final subItem = mealCategories[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipesByCategoryScreen(
                                category: subItem["label"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                subItem["icon"],
                                width: 40,
                                height: 40,
                              ),
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
            ]
            // Nếu chọn category khác thì load subCategories từ API backend
            else if (selectedCategory != null &&
                selectedCategory != "Món ăn") ...[
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
              if (isLoadingSub)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ).copyWith(bottom: 50),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.75,
                  ),
                  itemCount:
                      apiSubCategories.length + 1, // +1 để thêm ô dấu cộng
                  itemBuilder: (context, index) {
                    if (index == apiSubCategories.length) {
                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddFoodScreen(category: selectedCategory),
                            ),
                          );

                          if (result != null) {
                            debugPrint("Đã thêm mới: $result");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }

                    final subItem = apiSubCategories[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(
                                category: selectedCategory!,
                                subCategory: subItem["label"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                subItem["icon"],
                                width: 40,
                                height: 40,
                              ),
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
