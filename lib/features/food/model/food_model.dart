import 'package:uuid/uuid.dart';

class FoodItem {
  String id;
  String category;
  String name;
  int quantity;
  String location;
  String subLocation;
  DateTime registerDate;
  DateTime expiryDate;
  String note;

  static final _uuid = Uuid();

  FoodItem({
    String? id,
    required this.category,
    required this.name,
    this.quantity = 1,
    this.location = "Tủ lạnh",
    this.subLocation = "Không xác định",
    DateTime? registerDate,
    DateTime? expiryDate,
    this.note = "",
  }) : id =
           id ??
           DateTime.now().millisecondsSinceEpoch.toString(), // ✅ id theo giờ
       // : id = id ?? _uuid.v4(), // ✅ tự sinh id nếu chưa có
       registerDate = registerDate ?? DateTime.now(),
       expiryDate = expiryDate ?? DateTime.now().add(const Duration(days: 7));

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      // id: json['_id'] ?? json['id'] ?? _uuid.v4(),
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      location: json['location'] ?? 'Tủ lạnh',
      subLocation: json['subLocation'] ?? 'Không xác định',
      registerDate:
          DateTime.tryParse(json['registerDate'] ?? '') ?? DateTime.now(),
      expiryDate:
          DateTime.tryParse(json['expiryDate'] ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id, // ✅ luôn gửi kèm id
      "category": category,
      "name": name,
      "quantity": quantity,
      "location": location,
      "subLocation": subLocation,
      "registerDate": registerDate.toIso8601String(),
      "expiryDate": expiryDate.toIso8601String(),
      "note": note,
    };
  }
}
