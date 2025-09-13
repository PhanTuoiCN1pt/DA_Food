import 'package:da_food/helper/divider_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user/view/auth_screen.dart';

class SettingScreen extends StatelessWidget {
  final String name;
  final String email;

  const SettingScreen({super.key, required this.name, required this.email});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      _logout(context); // Gọi hàm logout hiện tại
    }
  }

  Widget _buildMenuItem(String iconPath, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(iconPath, width: 30, height: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header User Info
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row chứa back button + "Cài đặt"
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text(
                        "Cài đặt",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Row chứa avatar + tên + email + setting
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, bottom: 20),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "?",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Image.asset(
                        "assets/icons/icon_app/settings.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  "assets/icons/icon_app/informative.png",
                  "Thông báo",
                  () {},
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DashedDivider(dashSpace: 0, color: Colors.grey),
                ), // Divider thường
                _buildMenuItem(
                  "assets/icons/icon_app/handshake.png",
                  "Các điều khoản và điều kiện",
                  () {},
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DashedDivider(dashSpace: 0, color: Colors.grey),
                ), // Divid
                _buildMenuItem(
                  "assets/icons/icon_app/licensing.png",
                  "Giấy phép ứng dụng",
                  () {},
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DashedDivider(dashSpace: 0, color: Colors.grey),
                ), // Divid
                _buildMenuItem(
                  "assets/icons/icon_app/information.png",
                  "Thông tin ứng dụng",
                  () {},
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: DashedDivider(dashSpace: 0, color: Colors.grey),
                ), // Divid
                _buildMenuItem(
                  "assets/icons/icon_app/delete-user.png",
                  "Xóa tài khoản",
                  () {},
                ),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _confirmLogout(context),
              child: const Text(
                "Đăng xuất",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
