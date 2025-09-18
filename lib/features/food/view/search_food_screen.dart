import 'package:da_food/features/food/view_model/food_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/services/food_service.dart';
import '../../../helper/food_icon_helper.dart';
import '../../category/view/food_edit_screen.dart';
import '../model/food_model.dart';

class SearchFoodScreen extends StatefulWidget {
  const SearchFoodScreen({super.key});

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  final TextEditingController _controller = TextEditingController();
  List<FoodItem> _results = [];
  bool _loading = false;

  Future<void> _search(String keyword) async {
    setState(() => _loading = true);
    try {
      final foods = await FoodService.searchFoods(keyword);
      setState(() {
        _results = foods;
      });
    } catch (e) {
      debugPrint("Search error: $e");
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm thực phẩm...",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.roboto(fontSize: 16),
                    ),
                    onChanged: (value) {
                      _search(value.trim());
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _results.clear();
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final food = _results[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Image.asset(
                    FoodIconHelper.getIconByName(food.name),
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    food.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    final provider = Provider.of<FoodProvider>(
                      context,
                      listen: false,
                    );
                    provider.initFoodFromItem(food); //  Set food vào provider

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FoodEditScreen(food: food), // vẫn truyền vào screen
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
