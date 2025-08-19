import 'package:flutter/material.dart';

import 'circula_containe.dart';
import 'color_helper.dart';
import 'cuved_edges.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container(
        width: double.infinity,
        color: Colors.blue,
        child: Stack(
          children: [
            /// Vòng tròn background
            Positioned(
              top: -150,
              right: -250,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),

            /// Nội dung chính (AppBar, text…)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // tuỳ chỉnh khoảng cách
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
