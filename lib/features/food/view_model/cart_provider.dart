import 'package:flutter/material.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/services/user_service.dart';
import '../model/user_model.dart';

class CartProvider extends ChangeNotifier {
  final String userId;
  UserModel? user;
  bool loading = false;

  bool selectionMode = false;
  Set<String> selectedIds = {};

  CartProvider(this.userId) {
    loadUser();
  }

  int get pendingCartCount =>
      user?.cart.where((item) => !item.done).length ?? 0;

  Future<void> loadUser() async {
    loading = true;
    notifyListeners();
    try {
      user = await UserService.fetchUserById(userId);
    } catch (e) {
      debugPrint("❌ Lỗi load user: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String name) async {
    try {
      await CartService.addToCart(name);
      await loadUser();
    } catch (e) {
      debugPrint("❌ Lỗi thêm sản phẩm: $e");
    }
  }

  Future<void> deleteSelected() async {
    try {
      await CartService.deleteCartItems(selectedIds.toList());
      selectionMode = false;
      selectedIds.clear();
      await loadUser();
    } catch (e) {
      debugPrint("❌ Lỗi xóa sản phẩm: $e");
    }
  }

  Future<void> toggleItemDone(String id, bool done) async {
    try {
      await CartService.updateCartItemDone(id, done);
      final item = user?.cart.firstWhere((c) => c.id == id);
      if (item != null) item.done = done;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Lỗi cập nhật trạng thái: $e");
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void enableSelection(String id) {
    selectionMode = true;
    selectedIds.add(id);
    notifyListeners();
  }

  void disableSelection() {
    selectionMode = false;
    selectedIds.clear();
    notifyListeners();
  }
}
