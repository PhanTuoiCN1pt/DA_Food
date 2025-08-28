import 'dart:math';

import 'package:da_food/core/services/auth_server.dart';
import 'package:da_food/features/user/view/widget/constants.dart';
import 'package:da_food/features/user/view/widget/login_form.dart';
import 'package:da_food/features/user/view/widget/signup_form.dart';
import 'package:da_food/features/user/view/widget/social_btn.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'loading_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isShowSignUp = false;

  late AnimationController _animationController;
  late Animation<double> _animationTextRotate;

  final _formKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  // 👇 controller để lấy dữ liệu từ LoginForm
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Register
  final TextEditingController nameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();

  void setUpAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );
    _animationTextRotate = Tween<double>(
      begin: 0,
      end: 90,
    ).animate(_animationController);
  }

  void updateView() {
    setState(() {
      _isShowSignUp = !_isShowSignUp;
      // emailController.dispose();
      // passwordController.dispose();
    });
    _isShowSignUp
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  void initState() {
    setUpAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // 👈 ngăn layout bị đẩy khi bàn phím hiện lên
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Stack(
              children: [
                // Login
                AnimatedPositioned(
                  duration: defaultDuration,
                  width: _size.width * 0.88,
                  height: _size.height,
                  right: _isShowSignUp
                      ? _size.width * 0.88
                      : _size.width * 0.12,
                  child: GestureDetector(
                    onTap: () {
                      if (_isShowSignUp) updateView();
                      emailController.clear();
                      passwordController.clear();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFA8E6CF), // tím
                            Color(0xFFFFF3E0), // xanh dương
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),

                      child: LoginForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: _formKey,
                      ),
                    ),
                  ),
                ),

                // Sign up
                AnimatedPositioned(
                  duration: defaultDuration,
                  height: _size.height,
                  width: _size.width * 0.88,
                  left: _isShowSignUp ? _size.width * 0.12 : _size.width * 0.88,
                  child: GestureDetector(
                    onTap: () {
                      if (!_isShowSignUp) updateView();
                      nameController.clear();
                      signupEmailController.clear();
                      signupPasswordController.clear();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1C1C1C), // tím
                            Color(0xFFB87333), // xanh dương
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SignUpForm(
                        nameController: nameController,
                        emailController: signupEmailController,
                        passwordController: signupPasswordController,
                        signUpFormKey: _signupKey,

                        // confirmController:
                        //     TextEditingController(), // nếu bạn muốn confirm password
                      ),
                    ),
                  ),
                ),

                // Logo
                AnimatedPositioned(
                  duration: defaultDuration,
                  top: _size.height * 0.06,
                  left: 0,
                  right: _isShowSignUp
                      ? -_size.width * 0.06
                      : _size.width * 0.06,
                  child: _isShowSignUp
                      ? Lottie.asset(
                          "assets/animations/Green Login.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        )
                      : Lottie.asset(
                          "assets/animations/j28uCA3Jg9.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                ),

                // Btn social
                AnimatedPositioned(
                  duration: defaultDuration,
                  width: _size.width,
                  bottom: _size.height * 0.1,
                  right: _isShowSignUp
                      ? -_size.width * 0.06
                      : _size.width * 0.06,
                  child: SocialBtn(),
                ),

                // Login Text
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: _isShowSignUp
                      ? _size.height / 2 - 80
                      : _size.height * 0.3,
                  left: _isShowSignUp ? 0 : _size.width * 0.44 - 80,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _isShowSignUp ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: Transform.rotate(
                      angle: -_animationTextRotate.value * pi / 180,
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        // Login button
                        onTap: () {
                          if (_isShowSignUp) updateView();

                          if (_formKey.currentState!.validate()) {
                            AuthService.login(
                              context: context,
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              onSuccess: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoadingScreen(),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        // 👈 gọi API khi bấm
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            vertical: defpaultPadding * 0.75,
                          ),

                          width: 180,
                          child: Text(
                            "Đăng nhập".toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Signup text
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: !_isShowSignUp
                      ? _size.height / 2 - 80
                      : _size.height * 0.3,
                  right: _isShowSignUp ? _size.width * 0.44 - 80 : 0,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: !_isShowSignUp ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: Transform.rotate(
                      angle: (90 - _animationTextRotate.value) * pi / 180,
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        // Register button
                        onTap: () {
                          if (!_isShowSignUp) updateView();

                          if (_signupKey.currentState!.validate()) {
                            AuthService.register(
                              context: context,
                              name: nameController.text.trim(),
                              email: signupEmailController.text.trim(),
                              password: signupPasswordController.text.trim(),
                              onSuccess: () {
                                setState(() {
                                  _isShowSignUp = false;
                                  _animationController.reverse();
                                });
                              },
                            );
                          }
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: defpaultPadding * 0.75,
                          ),
                          width: 160,
                          child: Text(
                            "Đăng ký".toUpperCase(),
                            style: TextStyle(color: Color(0xFFEEEEEE)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
