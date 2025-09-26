import 'cart_model.dart';

class UserModel {
  String? id;
  String name;
  String email;
  String password;
  String? fcmToken;
  DateTime? lastLogin;
  List<CartItem> cart;
  String? notifyTime;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.fcmToken,
    this.lastLogin,
    this.cart = const [],
    this.notifyTime,
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
      notifyTime: json['notifyTime'],
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
      "notifyTime": notifyTime,
    };
  }
}

/// Extension thêm tính năng tiện lợi cho UserModel
extension UserCartExtension on UserModel {
  int get pendingCartCount {
    return cart.where((item) => item.done == false).length;
  }
}
