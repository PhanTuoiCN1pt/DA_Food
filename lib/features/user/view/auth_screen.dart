import 'dart:math';

import 'package:da_food/features/user/view/widget/constants.dart';
import 'package:da_food/features/user/view/widget/login_form.dart';
import 'package:da_food/features/user/view/widget/signup_form.dart';
import 'package:da_food/features/user/view/widget/social_btn.dart';
import 'package:da_food/helper/color_helper.dart';
import 'package:flutter/material.dart';

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
                child: Container(color: TColors.colorApp, child: LoginForm()),
              ),

              // Sign up
              AnimatedPositioned(
                duration: defaultDuration,
                height: _size.height,
                width: _size.width * 0.88,
                left: _isShowSignUp ? _size.width * 0.12 : _size.width * 0.88,

                child: Container(color: Colors.red, child: SignUpForm()),
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

              //Btn social
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
                    fontSize: _isShowSignUp ? 20 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  child: Transform.rotate(
                    angle: -_animationTextRotate.value * pi / 180,
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        if (_isShowSignUp) {
                          updateView();
                        } else {
                          //login
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: defpaultPadding * 0.75,
                        ),
                        width: 160,
                        child: Text("Log In".toUpperCase()),
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
                    fontSize: !_isShowSignUp ? 20 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  child: Transform.rotate(
                    angle: (90 - _animationTextRotate.value) * pi / 180,
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        if (_isShowSignUp) {
                          // Login
                        } else {
                          updateView();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: defpaultPadding * 0.75,
                        ),
                        width: 160,
                        child: Text("SignUp".toUpperCase()),
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
