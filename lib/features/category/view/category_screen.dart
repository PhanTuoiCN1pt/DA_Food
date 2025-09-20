import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_food/features/category/view/recipes_by_category_screen.dart';
import 'package:da_food/features/category/view/search_subcategory_screen.dart';
import 'package:da_food/features/category/view_model/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_food_screen.dart';
import 'food_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final selectedCategory = provider.selectedCategory;

    // Nếu chọn "Món ăn" mà chưa có data thì load từ API
    if (selectedCategory == "Món ăn" &&
        provider.recipeCategories.isEmpty &&
        !provider.isLoadingRecipe) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CategoryProvider>().loadRecipeCategories();
      });
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "Danh mục",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchSubCategoryScreen()),
              );
            },
            icon: Icon(Icons.search),
          ),
          const SizedBox(width: 8),
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
              itemCount: provider.allCategories.length,
              itemBuilder: (context, index) {
                final item = provider.allCategories[index];
                final isSelected = item.label == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    provider.selectCategory(item.label);
                    if (item.label != "Món ăn") {
                      provider.loadSubCategories(item.id);
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
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(item.icon, width: 40, height: 40),
                        const SizedBox(height: 6),
                        AutoSizeText(
                          item.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          minFontSize: 8,
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

            if (selectedCategory == "Món ăn") ...[
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  "Món ăn",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              if (provider.isLoadingRecipe)
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
                  itemCount: provider.recipeCategories.length,
                  itemBuilder: (context, index) {
                    final subItem = provider.recipeCategories[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipesBySubCategoryScreen(
                              category: subItem["label"],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(subItem["icon"], width: 40, height: 40),
                            const SizedBox(height: 6),
                            AutoSizeText(
                              subItem["label"],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 8,
                              maxFontSize: 13,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ] else if (selectedCategory != null) ...[
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                child: Text(
                  selectedCategory,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (provider.isLoadingSub)
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
                  itemCount: provider.apiSubCategories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == provider.apiSubCategories.length) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddFoodScreen(category: selectedCategory),
                            ),
                          );
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
                    final subItem = provider.apiSubCategories[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(
                                category: selectedCategory,
                                subCategory: subItem["label"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.maxFinite,
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
                              AutoSizeText(
                                subItem["label"],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                minFontSize: 8,
                                maxFontSize: 13,
                                overflow: TextOverflow.ellipsis,
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
