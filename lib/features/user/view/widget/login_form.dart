import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.13,
      ),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Quen mat khau",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
