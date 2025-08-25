import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/food_icon_helper.dart';
import '../../food/model/food_model.dart';
import '../../food/view_model/food_provider.dart';
import '../../food/view_model/foods_provider.dart';

class FoodEditScreen extends StatelessWidget {
  final FoodItem food;

  const FoodEditScreen({super.key, required this.food});

  Future<void> _pickDate(BuildContext context, bool isRegister) async {
    final provider = Provider.of<FoodProvider>(context, listen: false);
    final currentDate = isRegister
        ? provider.food.registerDate
        : provider.food.expiryDate;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isRegister) {
        provider.updateRegisterDate(picked);
      } else {
        provider.updateExpiryDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodProvider>(context, listen: false);
    provider.initFoodFromItem(food); // Khởi tạo dữ liệu từ FoodItem

    return Scaffold(
      appBar: AppBar(
        title: Consumer<FoodProvider>(
          builder: (_, provider, __) => Text(provider.food.name),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<FoodProvider>(
          builder: (_, provider, __) {
            final f = provider.food;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + Category + Editable Name
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          FoodIconHelper.getIconByName(f.name),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.category,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: provider.nameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: provider.updateName,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Vị trí
                  Row(
                    children: [
                      Text(
                        "Vị trí",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          value: food.location,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          items: ["Tủ lạnh", "Tủ đông", "Nhà bếp"]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              provider.updateLocation(value ?? "Tủ lạnh"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Số lượng
                  Row(
                    children: [
                      const Text(
                        "Số lượng",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if (food.quantity > 1) {
                            provider.updateQuantity(food.quantity - 1);
                          }
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        food.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),

                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () =>
                            provider.updateQuantity(food.quantity + 1),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // Ngày đăng ký
                  Row(
                    children: [
                      Text(
                        "Ngày mua",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                        onPressed: () => _pickDate(context, true),
                        child: Text(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          "${food.registerDate.day}/${food.registerDate.month}/${food.registerDate.year}",
                        ),
                      ),
                    ],
                  ),

                  // Ngày hết hạn
                  Row(
                    children: [
                      const Text(
                        "Ngày hết hạn",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          side: BorderSide(color: Colors.black, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _pickDate(context, false),
                        child: Text(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          "${food.expiryDate.day}/${food.expiryDate.month}/${food.expiryDate.year}",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Ghi chú
                  TextField(
                    controller: provider.noteController,
                    decoration: InputDecoration(
                      hintText: "Nhấn để viết ghi nhớ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 3,
                    onChanged: provider.updateNote,
                  ),

                  const SizedBox(height: 30),

                  // Button Cập nhật
                  // Button Cập nhật
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        final foodProvider = Provider.of<FoodProvider>(
                          context,
                          listen: false,
                        );
                        final foodsProvider = Provider.of<FoodsProvider>(
                          context,
                          listen: false,
                        );

                        // Gọi update (local hoặc API tuỳ implementation)
                        await foodsProvider.updateFood(foodProvider.food);

                        // Quay lại màn trước
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "CẬP NHẬT",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
