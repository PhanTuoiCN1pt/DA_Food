import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(child: Text(text, style: const TextStyle(fontSize: 18))),
    );
  }
}
