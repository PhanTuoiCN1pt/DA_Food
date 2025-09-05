import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/rounded_underline_indicator.dart';

class HomeHeader extends StatelessWidget {
  final TabController tabController;
  final String username;
  final List<String> labels;

  const HomeHeader({
    super.key,
    required this.tabController,
    required this.username,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header title + icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Food AI x $username",
                style: GoogleFonts.oswald(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 TabBar có controller
          TabBar(
            controller: tabController, // ✅ Bắt buộc
            isScrollable: false,
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelPadding: const EdgeInsets.symmetric(vertical: 12),
            indicator: const RoundedUnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: Colors.white),
              radius: 6.0,
              insets: EdgeInsets.symmetric(horizontal: 12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: List.generate(labels.length, (index) {
              return Text(
                labels[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
