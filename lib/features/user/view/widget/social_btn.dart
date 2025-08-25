import 'package:flutter/material.dart';

class SocialBtn extends StatelessWidget {
  const SocialBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/icons/logo/facebook-logo.png",
            width: 30,
            height: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/icons/logo/google-symbol.png",
            width: 30,
            height: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/icons/logo/facebook-logo.png",
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
