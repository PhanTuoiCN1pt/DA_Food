import 'package:da_food/features/food/view/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/user_model.dart';
import '../widget/rounded_underline_indicator.dart';

class HomeHeader extends StatelessWidget {
  final TabController tabController;
  final String username;
  final List<String> labels;
  final UserModel? user;

  const HomeHeader({
    super.key,
    required this.tabController,
    required this.username,
    required this.labels,
    this.user,
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
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CartScreen(userId: user!.id.toString()),
                          ),
                        );
                      }
                    },
                    icon: Image.asset(
                      "assets/icons/icon_app/add-to-cart.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 TabBar
          TabBar(
            controller: tabController,
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
            tabs: labels
                .map(
                  (label) => Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
