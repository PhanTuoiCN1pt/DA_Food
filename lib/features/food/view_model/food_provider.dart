import 'package:flutter/material.dart';

import '../model/food_model.dart';

class FoodProvider with ChangeNotifier {
  FoodItem? _food;

  // Controllers cho text input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  FoodItem get food => _food!;

  /// Khởi tạo food mới (chỉ khi chưa có)
  void initFood({required String category, required String name}) {
    if (_food == null) {
      _food = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch
            .toString(), // tự tạo id theo giờ
        category: category,
        name: name,
        quantity: 1,
        location: "Tủ lạnh",
        subLocation: "Không xác định",
        registerDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        note: "",
      );
    } else {
      // Nếu đã có rồi thì chỉ cập nhật lại category + name thôi
      _food!.category = category;
      _food!.name = name;
    }

    // đồng bộ controller
    nameController.text = _food!.name;
    noteController.text = _food!.note;
    notifyListeners();
  }

  /// Khởi tạo từ một item có sẵn (edit)
  void initFoodFromItem(FoodItem item) {
    _food = item;
    nameController.text = item.name;
    noteController.text = item.note;
    notifyListeners();
  }

  // ================== Update field ==================
  void updateName(String name) {
    _food?.name = name;
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    _food?.quantity = quantity;
    notifyListeners();
  }

  void updateLocation(String loc) {
    _food?.location = loc;
    notifyListeners();
  }

  void updateSubLocation(String subLoc) {
    _food?.subLocation = subLoc;
    notifyListeners();
  }

  void updateRegisterDate(DateTime date) {
    _food?.registerDate = date;
    notifyListeners();
  }

  void updateExpiryDate(DateTime date) {
    _food?.expiryDate = date;
    notifyListeners();
  }

  void updateNote(String note) {
    _food?.note = note;
    notifyListeners();
  }

  // ================== Convert ==================
  Map<String, dynamic> toJson() => _food?.toJson() ?? {};

  // cleanup khi không dùng nữa
  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
