import 'package:flutter/material.dart';

class SocialBtn extends StatelessWidget {
  const SocialBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // IconButton(
        //   onPressed: () {},
        //   icon: Image.asset(
        //     "assets/icons/icon_app/icon_app_no_text.png",
        //     width: 150,
        //     height: 150,
        //   ),
        // ),
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
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/icons/logo/twitter.png",
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
