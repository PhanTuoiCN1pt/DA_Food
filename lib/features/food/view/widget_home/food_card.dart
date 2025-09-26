import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../helper/color_helper.dart';
import '../../../../helper/food_icon_helper.dart';
import '../../model/food_model.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final int daysLeft;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.daysLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định text và màu nền theo daysLeft
    final bool isExpired = daysLeft <= 0;
    final bool isSafe = daysLeft > 2;

    final String dayText = isExpired ? "D+${daysLeft.abs()}" : "D-$daysLeft";

    final Color bgColor = isExpired
        ? Colors.red
        : (isSafe ? Colors.green : Colors.yellow);

    final Color textColor = isExpired
        ? Colors.white
        : (isSafe ? Colors.white : Colors.black);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          color: bgColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          dayText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(5, -1),
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
      ),
    );
  }
}
