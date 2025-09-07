import 'package:flutter/material.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/services/user_server.dart';
import '../model/user_model.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _reloadUser();
  }

  Future<UserModel> _reloadUser() async {
    return await UserServer.fetchUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách mua sắm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<UserModel>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("❌ Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.cart.isEmpty) {
            return const Center(child: Text("Giỏ hàng trống"));
          }

          final items = snapshot.data!.cart;

          // Sắp xếp: chưa done lên đầu, done xuống cuối
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

              return ListTile(
                title: Text(
                  item.foodName,
                  style: TextStyle(
                    decoration: item.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: item.done ? Colors.grey : Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.expand_more),
                onTap: () async {
                  final newDone = !item.done;
                  setState(() {
                    item.done = newDone; // cập nhật ngay trên UI
                  });
                  try {
                    await CartService.updateCartItemDone(item.id, newDone);
                  } catch (e) {
                    setState(() {
                      item.done = !newDone; // rollback nếu API lỗi
                    });
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
