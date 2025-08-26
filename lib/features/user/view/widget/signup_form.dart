import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> signUpFormKey;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.signUpFormKey,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIconColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 13),
    );

    return Form(
      key: signUpFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.13,
        ),
        child: Column(
          children: [
            const Spacer(),

            /// Name
            TextFormField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration.copyWith(
                labelText: "Tên",
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập tên";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            /// Email
            TextFormField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration.copyWith(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập email";
                }
                if (!value.contains("@")) {
                  return "Email không hợp lệ";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            /// Password
            TextFormField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: inputDecoration.copyWith(
                labelText: "Mật khẩu",
                prefixIcon: const Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập mật khẩu";
                }
                if (value.length < 6) {
                  return "Mật khẩu phải từ 6 ký tự";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
