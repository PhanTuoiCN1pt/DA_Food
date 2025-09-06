import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper/divider_helper.dart';
import '../../../category/view/food_edit_screen.dart';
import '../../model/food_model.dart';
import '../../view_model/food_provider.dart';
import 'food_card.dart';

class FoodTab extends StatelessWidget {
  final String locationLabel;
  List<FoodItem> foods = [];
  final VoidCallback? onReload;

  FoodTab({
    super.key,
    required this.locationLabel,
    required this.foods,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return const Center(child: Text("Không có thực phẩm nào"));
    }

    // Gom nhóm theo category
    final Map<String, List<FoodItem>> groupedFoods = {};
    for (var food in foods) {
      groupedFoods.putIfAbsent(food.category, () => []).add(food);
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: groupedFoods.entries.map((entry) {
        final categoryFoods = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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

            // Hiển thị tất cả food dạng Wrap
            Wrap(
              spacing: 12,
              runSpacing: 20,
              children: categoryFoods.map((food) {
                final daysLeft = food.expiryDate
                    .difference(DateTime.now())
                    .inDays;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) {
                            final provider = FoodProvider();
                            provider.initFoodFromItem(food);
                            return provider;
                          },
                          child: FoodEditScreen(food: food),
                        ),
                      ),
                    ).then((_) {
                      if (onReload != null) onReload!();
                    });
                  },
                  child: FoodCard(
                    food: food,
                    daysLeft: daysLeft,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodEditScreen(food: food),
                        ),
                      ).then((_) => {if (onReload != null) onReload!()});
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}
