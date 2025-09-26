import 'package:da_food/features/food/view/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/user_model.dart';
import '../search_food_screen.dart';
import '../setting_screen.dart';
import '../widget/rounded_underline_indicator.dart';

class HomeHeader extends StatelessWidget {
  final TabController tabController;
  final List<String> labels;
  final UserModel? user;

  const HomeHeader({
    super.key,
    required this.tabController,
    required this.labels,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D99AE), Color(0xFFBCFEFE)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title + icons
          Row(
            children: [
              // Bên trái: chữ
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Fridge x ${user?.name ?? ''}",
                    style: GoogleFonts.oswald(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Bên phải: icon
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SearchFoodScreen()),
                  );
                },
                icon: const Icon(Icons.search, size: 28, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartScreen(userId: user!.id!),
                      ),
                    );
                  }
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      size: 28,
                      color: Colors.black,
                    ),
                    if (user != null && user!.pendingCartCount > 0)
                      Positioned(
                        right: -4,
                        top: -10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '${user!.pendingCartCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingScreen(user: user!),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.more_vert,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: TabBar(
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
              labelColor: Colors.black,
              unselectedLabelColor: Color(0xFF004D40),
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
          ),
        ],
      ),
    );
  }
}
