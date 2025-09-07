class CartItem {
  final String id;
  final String foodName;
  bool done;

  CartItem({required this.id, required this.foodName, this.done = false});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json["_id"] ?? "",
      foodName: json["foodName"] ?? "",
      done: json["done"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "foodName": foodName, "done": done};
  }
}
