import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/food_server.dart';
import '../../../helper/food_icon_helper.dart';
import '../../food/view_model/food_provider.dart';

class AddFoodScreen extends StatelessWidget {
  final String category;

  const AddFoodScreen({super.key, required this.category});

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

    // 👉 Khởi tạo food chỉ với category, name = "" để user nhập
    provider.initFood(category: category, name: "");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thêm sản phẩm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 18),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Image.asset(
                            FoodIconHelper.getIconByName(
                              provider.food.name.isEmpty
                                  ? "default"
                                  : provider.food.name,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              food.category,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Editable Name (rỗng cho user nhập)
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.0,
                              bottom: 20,
                              top: 10,
                            ),
                            child: Container(
                              child: SizedBox(
                                width: 200,
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: "Nhập tên món ăn...",

                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                    ),
                                    isDense: true, // thu hẹp padding mặc định
                                    contentPadding:
                                        EdgeInsets.zero, // bỏ padding mặc định
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Ngày mua
                  Row(
                    children: [
                      const Text(
                        "Ngày mua",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 120,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          onPressed: () => _pickDate(context, true),
                          child: Text(
                            "${food.registerDate.day}/${food.registerDate.month}/${food.registerDate.year}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

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
                      SizedBox(
                        width: 120,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _pickDate(context, false),
                          child: Text(
                            "${food.expiryDate.day}/${food.expiryDate.month}/${food.expiryDate.year}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                      child: const Text(
                        "Thiết lập lại",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Button thêm food
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
                      onPressed: () {
                        if (food.name.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Vui lòng nhập tên sản phẩm"),
                            ),
                          );
                          return;
                        }

                        FoodService.addFood(food); // 👉 Lưu vào user
                        Navigator.pop(context);
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
