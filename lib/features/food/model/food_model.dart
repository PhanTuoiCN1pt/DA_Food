class FoodItem {
  String id;
  String userId;
  String category;
  String name;
  int quantity;
  String location;
  String subLocation;
  DateTime registerDate;
  DateTime expiryDate;
  String note;
  int storageDuration;

  FoodItem({
    String? id,
    required this.userId,
    required this.category,
    required this.name,
    this.quantity = 1,
    this.location = "Tủ lạnh",
    this.subLocation = "Không xác định",
    DateTime? registerDate,
    int storageDuration = 7, // mặc định 7 ngày
    DateTime? expiryDate,
    this.note = "",
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       registerDate = registerDate ?? DateTime.now(),
       storageDuration = storageDuration,
       expiryDate =
           expiryDate ??
           (registerDate ?? DateTime.now()).add(
             Duration(days: storageDuration),
           );

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    int duration = json['storageDuration'] ?? 7;
    DateTime regDate =
        DateTime.tryParse(json['registerDate'] ?? '') ?? DateTime.now();

    return FoodItem(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: json['userId'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      location: json['location'] ?? 'Tủ lạnh',
      subLocation: json['subLocation'] ?? 'Không xác định',
      registerDate: regDate,
      storageDuration: duration,
      expiryDate:
          DateTime.tryParse(json['expiryDate'] ?? '') ??
          regDate.add(Duration(days: duration)),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "category": category,
      "name": name,
      "quantity": quantity,
      "location": location,
      "subLocation": subLocation,
      "registerDate": registerDate.toIso8601String(),
      "expiryDate": expiryDate.toIso8601String(),
      "storageDuration": storageDuration,
      "note": note,
    };
  }
}
