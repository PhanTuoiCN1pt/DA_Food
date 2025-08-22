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
                      const Text(
                        "Vị trí",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: f.location,
                        items: ["Tủ lạnh", "Tủ đông", "Nhà bếp"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            provider.updateLocation(value ?? "Tủ lạnh"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Vị trí con
                  Row(
                    children: [
                      const Text(
                        "Vị trí con",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: f.subLocation,
                        items: ["Không xác định", "Ngăn trên", "Ngăn dưới"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) => provider.updateSubLocation(
                          value ?? "Không xác định",
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
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if (f.quantity > 1) {
                            provider.updateQuantity(f.quantity - 1);
                          }
                        },
                      ),
                      Text(
                        f.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () =>
                            provider.updateQuantity(f.quantity + 1),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // Ngày đăng ký
                  Row(
                    children: [
                      const Text(
                        "Ngày đăng kí",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _pickDate(context, true),
                        child: Text(
                          "${f.registerDate.day}/${f.registerDate.month}/${f.registerDate.year}",
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
                        onPressed: () => _pickDate(context, false),
                        child: Text(
                          "${f.expiryDate.day}/${f.expiryDate.month}/${f.expiryDate.year}",
                        ),
                      ),
                      TextButton(
                        onPressed: () => provider.updateExpiryDate(
                          DateTime.now().add(const Duration(days: 7)),
                        ),
                        child: const Text("Thiết lập lại"),
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
                      onPressed: () {
                        final foodsProvider = Provider.of<FoodsProvider>(
                          context,
                          listen: false,
                        );

                        foodsProvider.updateFood(f); // cập nhật food hiện tại
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
