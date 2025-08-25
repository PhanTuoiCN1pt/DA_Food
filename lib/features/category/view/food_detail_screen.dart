import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/food_icon_helper.dart';
import '../../food/view_model/food_api.dart';
import '../../food/view_model/food_provider.dart';
import '../../food/view_model/foods_provider.dart';

class FoodDetailScreen extends StatelessWidget {
  final String category;
  final String subCategory;

  const FoodDetailScreen({
    super.key,
    required this.category,
    required this.subCategory,
  });

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
    provider.initFood(category: category, name: subCategory);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<FoodProvider>(
          builder: (context, provider, _) =>
              Text(provider.food.name), // tên có thể sửa
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [Icon(Icons.shopping_bag_outlined), SizedBox(width: 10)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<FoodProvider>(
          builder: (context, provider, _) {
            final food = provider.food;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + Category + Editable Name
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.grey.shade400),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        child: Image.asset(
                          FoodIconHelper.getIconByName(provider.food.name),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.category,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Editable Name
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
                              onChanged: provider.updateName, // cập nhật model
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
                            fillColor: Colors.grey.shade400,
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

                  SizedBox(height: 10),

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

                  SizedBox(height: 10),

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
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => provider.updateExpiryDate(
                        DateTime.now().add(const Duration(days: 7)),
                      ),
                      child: Text(
                        "Thiết lập lại",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
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

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blueAccent,
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

                        final food = foodProvider.food;

                        // ✅ gọi API để lưu vào backend
                        final success = await FoodApi.addFood(food);

                        if (success) {
                          foodsProvider.addFoodLocal(
                            food,
                          ); // thêm vào local list
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Đã thêm vào server")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Lỗi khi thêm food")),
                          );
                        }
                      },

                      child: const Text(
                        "THÊM VÀO",
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
