import 'cart_model.dart';

class UserModel {
  String? id;
  String name;
  String email;
  String password;
  String? fcmToken;
  DateTime? lastLogin;
  List<CartItem> cart;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.fcmToken,
    this.lastLogin,
    this.cart = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString(),
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      fcmToken: json['fcmToken'],
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'])
          : null,
      cart: (json['cart'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id,
      "name": name,
      "email": email,
      "password": password,
      "fcmToken": fcmToken,
      "lastLogin": lastLogin?.toIso8601String(),
      "cart": cart.map((e) => e.toJson()).toList(),
    };
  }
}
