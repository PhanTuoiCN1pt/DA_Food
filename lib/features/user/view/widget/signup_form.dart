import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
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
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      prefixIconColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
    );

    return Form(
      key: widget.signUpFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.12,
        ),
        child: Column(
          children: [
            const Spacer(),
            SizedBox(height: 95),

            /// Name
            TextFormField(
              controller: widget.nameController,
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
            const SizedBox(height: 25),

            /// Email
            TextFormField(
              controller: widget.emailController,
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
            const SizedBox(height: 25),

            /// Password
            TextFormField(
              controller: widget.passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: _obscureText,
              decoration: inputDecoration.copyWith(
                labelText: "Mật khẩu",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                ),
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
