import 'package:uuid/uuid.dart';

class FoodItem {
  String id; // ✅ thêm id
  String category;
  String name;
  int quantity;
  String location;
  String subLocation;
  DateTime registerDate;
  DateTime expiryDate;
  String note;

  FoodItem({
    String? id, // cho phép tự truyền id hoặc tạo mới
    required this.category,
    required this.name,
    this.quantity = 1,
    this.location = "Tủ lạnh",
    this.subLocation = "Không xác định",
    DateTime? registerDate,
    DateTime? expiryDate,
    this.note = "",
  }) : id = id ?? const Uuid().v4(), // nếu không truyền id, tự sinh UUID
       registerDate = registerDate ?? DateTime.now(),
       expiryDate = expiryDate ?? DateTime.now().add(const Duration(days: 7));
}
