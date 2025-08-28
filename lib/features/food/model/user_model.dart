class UserModel {
  String? id; // _id của MongoDB (có thể null khi tạo mới)
  String name;
  String email;
  String password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString(), // MongoDB trả về _id
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id, // khi update thì gửi _id
      "name": name,
      "email": email,
      "password": password,
    };
  }
}
