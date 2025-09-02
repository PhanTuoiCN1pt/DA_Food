import 'package:auto_size_text/auto_size_text.dart';
import 'package:da_food/features/category/view/food_edit_screen.dart';
import 'package:da_food/features/food/view/meal_suggestions_screen.dart';
import 'package:da_food/features/food/view/widget/rounded_underline_indicator.dart';
import 'package:da_food/helper/color_helper.dart';
import 'package:da_food/helper/divider_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/food_server.dart';
import '../../../core/services/user_server.dart';
import '../../../helper/food_icon_helper.dart';
import '../model/food_model.dart';
import '../model/recipe_model.dart';
import '../model/user_model.dart';
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

  bool isLoading = true;
  List<FoodItem> foods = [];
  UserModel? user;

  Future<void> _showMealSuggestions() async {
    if (user == null || user!.id == null) return;

    // Hiển thị loading
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Lấy danh sách suggestions từ API trực tiếp
      final List<RecipeModel> suggestions =
          await FoodService.getMealSuggestions(user!.id!);

      Navigator.pop(context); // đóng loading

      if (suggestions.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Gợi ý món ăn"),
            content: const Text(
              "Không tìm thấy món phù hợp với thực phẩm hiện có.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      // Hiển thị danh sách món ăn
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final recipe = suggestions[index];
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Nguyên liệu:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...recipe.ingredients.map(
                        (i) => Text("- ${i.name}: ${i.quantity}"),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Hướng dẫn:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...recipe.instructions.map((step) => Text("- $step")),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // đóng loading nếu lỗi
      print("Error fetching meal suggestions: $e");

      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Lỗi"),
          content: Text("Không thể lấy gợi ý món ăn.\nLỗi: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _loadFoods() async {
    setState(() => isLoading = true);
    try {
      foods = await FoodService.fetchFoods(); // tự động lọc theo userId
    } catch (e) {
      print("Error loading foods: $e");
      foods = [];
    }
    setState(() => isLoading = false);
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "";

    if (userId.isNotEmpty) {
      try {
        final fetchedUser = await UserServer.fetchUserById(userId);
        setState(() {
          user = fetchedUser;
        });
      } catch (e) {
        print("Error fetching user: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = TabProvider(); // không cần Provider nữa

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
                    _buildHeader(tabProvider, user?.name ?? "Đang tải..."),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.grey,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : foods.isEmpty
                            ? const Center(child: Text("Chưa có thực phẩm nào"))
                            : _buildTabBarView(foods),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: "suggestMeal",
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.restaurant_menu),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealSuggestionsScreen(user: user!),
                        ),
                      ),
                    },
                  ),
                ),
              ],
            ),

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
                    _loadFoods(); // reload sau khi pop
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(TabProvider tabProvider, String username) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Food AI x $username",
                style: GoogleFonts.oswald(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
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
          const SizedBox(height: 10),
          TabBar(
            onTap: (index) => tabProvider.setTab(index),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelPadding: const EdgeInsets.only(bottom: 0, top: 16),
            indicator: const RoundedUnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: Colors.white),
              radius: 6.0,
              insets: EdgeInsets.symmetric(horizontal: 8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: List.generate(labels.length, (index) {
              return Tab(
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

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

        final Map<String, List<FoodItem>> groupedByCategory = {};
        for (var f in filteredFoods) {
          groupedByCategory.putIfAbsent(f.category, () => []).add(f);
        }

        return ListView(
          padding: const EdgeInsets.only(top: 10),
          children: groupedByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${entry.key} (${entry.value.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: DashedDivider()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 20,
                    children: entry.value.map((food) {
                      final daysLeft = food.expiryDate
                          .difference(DateTime.now())
                          .inDays;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodEditScreen(food: food),
                            ),
                          ).then((_) => _loadFoods());
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

  Widget _buildFoodItem(FoodItem food, int daysLeft) {
    return Container(
      width: 86,
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
                  margin: const EdgeInsets.all(4),
                  child: Transform.translate(
                    offset: const Offset(-10, -10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                offset: const Offset(10, -1),
                child: SizedBox(
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
            offset: const Offset(0, -10),
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
              padding: const EdgeInsets.all(6),
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
