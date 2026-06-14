import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../state/cart_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'cart_screen.dart';
import 'discover_screen.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

/// Khung chính của app sau khi đăng nhập: chứa 5 tab điều hướng dưới cùng.
/// Trạng thái giỏ hàng nằm ở [CartController] (singleton).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _cart = CartController.instance;

  /// Thêm món vào giỏ + hiện thông báo nhanh.
  void _addToCart(FoodItem item) {
    _cart.add(item);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Đã thêm "${item.name}" vào giỏ'),
        duration: const Duration(seconds: 1),
      ));
  }

  @override
  Widget build(BuildContext context) {
    // IndexedStack giữ trạng thái mỗi tab khi chuyển qua lại.
    final pages = [
      HomeScreen(
        onAddToCart: _addToCart,
        onSeeAll: () => setState(() => _index = 1),
      ),
      const DiscoverScreen(),
      const CartScreen(),
      const OrderHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      // Lắng nghe giỏ hàng để cập nhật badge số lượng.
      bottomNavigationBar: ListenableBuilder(
        listenable: _cart,
        builder: (context, _) => BottomNavBar(
          currentIndex: _index,
          cartCount: _cart.itemCount,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
