import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  void _showAddItemDialog(BuildContext context, CartProvider provider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm vào giỏ hàng"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Tên thực phẩm",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context);
              await provider.addItem(name);
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(userId),
      child: Consumer<CartProvider>(
        builder: (context, provider, child) {
          final user = provider.user;

          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: provider.selectionMode
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: provider.disableSelection,
                    )
                  : null,
              title: Text(
                provider.selectionMode ? "Xóa khỏi giỏ" : "Danh sách mua sắm",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                if (provider.selectionMode)
                  IconButton(
                    icon: Image.asset(
                      "assets/icons/icon_app/garbage.png",
                      width: 30,
                      height: 30,
                    ),
                    onPressed: provider.selectedIds.isEmpty
                        ? null
                        : provider.deleteSelected,
                  ),
                const SizedBox(width: 10),
              ],
            ),

            body: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : (user == null || user.cart.isEmpty)
                ? const Center(child: Text("Giỏ hàng trống"))
                : ListView.separated(
                    itemCount: user.cart.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      // Sắp xếp done xuống cuối
                      final sortedItems = [...user.cart]
                        ..sort((a, b) {
                          if (a.done == b.done) return 0;
                          return a.done ? 1 : -1;
                        });
                      final item = sortedItems[index];
                      final isSelected = provider.selectedIds.contains(item.id);

                      return ListTile(
                        leading: provider.selectionMode
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (_) =>
                                    provider.toggleSelection(item.id),
                              )
                            : null,
                        title: Text(
                          item.foodName,
                          style: TextStyle(
                            decoration: item.done
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: item.done ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: !provider.selectionMode
                            ? const Icon(Icons.expand_more)
                            : null,
                        onTap: () {
                          if (provider.selectionMode) {
                            provider.toggleSelection(item.id);
                          } else {
                            provider.toggleItemDone(item.id, !item.done);
                          }
                        },
                        onLongPress: () => provider.enableSelection(item.id),
                      );
                    },
                  ),

            floatingActionButton: !provider.selectionMode
                ? FloatingActionButton(
                    onPressed: () => _showAddItemDialog(context, provider),
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}
