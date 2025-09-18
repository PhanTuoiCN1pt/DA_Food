import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/category_service.dart';
import '../../food/model/category_model.dart';
import 'food_detail_screen.dart';

class SearchSubCategoryScreen extends StatefulWidget {
  const SearchSubCategoryScreen({super.key});

  @override
  State<SearchSubCategoryScreen> createState() =>
      _SearchSubCategoryScreenState();
}

class _SearchSubCategoryScreenState extends State<SearchSubCategoryScreen> {
  final TextEditingController _controller = TextEditingController();
  List<SubCategory> _results = [];
  bool _loading = false;

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => _results.clear());
      return;
    }

    setState(() => _loading = true);
    try {
      final subs = await CategoryService().searchSubCategories(keyword);
      setState(() {
        _results = subs;
      });
    } catch (e) {
      debugPrint("Search error: $e");
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                      hintText: "Tìm kiếm subcategory...",
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
          : _results.isEmpty
          ? const Center(child: Text("Nhập tên thực phẩm để tìm kiếm"))
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final sub = _results[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: sub.icon.isNotEmpty
                      ? Image.asset(sub.icon, width: 40, height: 40)
                      : const Icon(Icons.category),
                  title: Text(
                    sub.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    sub.category,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodDetailScreen(
                          category: sub.category,
                          subCategory: sub.label,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
