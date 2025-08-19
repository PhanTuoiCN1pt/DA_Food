class FoodItem {
  String category;
  String name;
  int quantity;
  String location;
  String subLocation;
  DateTime registerDate;
  DateTime expiryDate;
  String note;

  FoodItem({
    required this.category,
    required this.name,
    this.quantity = 1,
    this.location = "Tủ lạnh",
    this.subLocation = "Không xác định",
    DateTime? registerDate,
    DateTime? expiryDate,
    this.note = "",
  }) : registerDate = registerDate ?? DateTime.now(),
       expiryDate = expiryDate ?? DateTime.now().add(const Duration(days: 7));
}
