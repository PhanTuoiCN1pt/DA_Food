import 'dart:math';

import 'package:da_food/features/user/view/widget/constants.dart';
import 'package:da_food/features/user/view/widget/login_form.dart';
import 'package:da_food/features/user/view/widget/signup_form.dart';
import 'package:da_food/features/user/view/widget/social_btn.dart';
import 'package:da_food/helper/color_helper.dart';
import 'package:flutter/material.dart';

import '../view_model/login_controller.dart';
import '../view_model/register_controller.dart';
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
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Stack(
            children: [
              // Login
              AnimatedPositioned(
                duration: defaultDuration,
                width: _size.width * 0.88,
                height: _size.height,
                right: _isShowSignUp ? _size.width * 0.88 : _size.width * 0.12,
                child: GestureDetector(
                  onTap: () {
                    if (_isShowSignUp) updateView();
                    emailController.clear();
                    passwordController.clear();
                  },
                  child: Container(
                    color: TColors.colorApp,
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
                    color: Colors.brown,
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
                top: _size.height * 0.1,
                left: 0,
                right: _isShowSignUp ? -_size.width * 0.06 : _size.width * 0.06,
                child: CircleAvatar(
                  radius: 25,
                  child: _isShowSignUp
                      ? Image.asset("assets/icons/category/fruit.png")
                      : Image.asset("assets/icons/category/dairy.png"),
                ),
              ),

              // Btn social
              AnimatedPositioned(
                duration: defaultDuration,
                width: _size.width,
                bottom: _size.height * 0.1,
                right: _isShowSignUp ? -_size.width * 0.06 : _size.width * 0.06,
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
                        if (_formKey.currentState!.validate()) {
                          LoginController.login(
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

                        width: 160,
                        child: Text(
                          "Đăng nhập".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
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
                        if (_signupKey.currentState!.validate()) {
                          RegisterController.register(
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
                        child: Text("Đăng ký".toUpperCase()),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
