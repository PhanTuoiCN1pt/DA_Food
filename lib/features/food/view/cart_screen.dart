import 'package:flutter/material.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/services/user_service.dart';
import '../model/user_model.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<UserModel> _futureUser;

  bool _selectionMode = false;
  Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _futureUser = _reloadUser();
  }

  Future<UserModel> _reloadUser() async {
    return await UserService.fetchUserById(widget.userId);
  }

  void _showAddItemDialog() {
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

              try {
                await CartService.addToCart(name);
                setState(() {
                  _futureUser = _reloadUser();
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lỗi thêm sản phẩm: $e")),
                );
              }
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  void _deleteSelected() async {
    try {
      await CartService.deleteCartItems(_selectedIds.toList());
      setState(() {
        _selectionMode = false;
        _selectedIds.clear();
        _futureUser = _reloadUser();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi xóa sản phẩm: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectionMode = false;
                    _selectedIds.clear();
                  });
                },
              )
            : null,
        title: Text(
          _selectionMode ? "Xóa khỏi giỏ" : "Danh sách mua sắm",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_selectionMode)
            IconButton(
              icon: Image.asset(
                "assets/icons/icon_app/garbage.png",
                width: 30,
                height: 30,
              ),
              onPressed: _selectedIds.isEmpty ? null : _deleteSelected,
            ),
          SizedBox(width: 10),
        ],
      ),

      body: FutureBuilder<UserModel>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.cart.isEmpty) {
            return const Center(child: Text("Giỏ hàng trống"));
          }

          final items = snapshot.data!.cart;

          final sortedItems = [...items]
            ..sort((a, b) {
              if (a.done == b.done) return 0;
              return a.done ? 1 : -1;
            });

          return ListView.separated(
            itemCount: sortedItems.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = sortedItems[index];
              final isSelected = _selectedIds.contains(item.id);

              return ListTile(
                leading: _selectionMode
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedIds.add(item.id);
                            } else {
                              _selectedIds.remove(item.id);
                            }
                          });
                        },
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
                trailing: !_selectionMode
                    ? const Icon(Icons.expand_more)
                    : null,
                onTap: () async {
                  if (_selectionMode) {
                    setState(() {
                      if (isSelected) {
                        _selectedIds.remove(item.id);
                      } else {
                        _selectedIds.add(item.id);
                      }
                    });
                  } else {
                    final newDone = !item.done;
                    setState(() {
                      item.done = newDone;
                    });
                    try {
                      await CartService.updateCartItemDone(item.id, newDone);
                    } catch (e) {
                      setState(() {
                        item.done = !newDone;
                      });
                    }
                  }
                },
                onLongPress: () {
                  setState(() {
                    _selectionMode = true;
                    _selectedIds.add(item.id);
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: !_selectionMode
          ? FloatingActionButton(
              onPressed: _showAddItemDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
