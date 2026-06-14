import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

/// Một mục trên thanh điều hướng dưới cùng.
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}

/// Thanh điều hướng dưới cùng với 5 mục, làm nổi mục đang chọn bằng màu xanh.
/// [cartCount] > 0 sẽ hiển thị badge số lượng trên mục Giỏ hàng (index 2).
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final int cartCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.cartCount = 0,
  });

  /// Mục có badge giỏ hàng.
  static const int _cartIndex = 2;

  /// Các mục - dùng icon mặc định gần với thiết kế nhất.
  static const List<NavItem> items = [
    NavItem(icon: Icons.home_outlined, label: 'Home'),
    NavItem(icon: Icons.style_outlined, label: 'Khám phá'),
    NavItem(icon: Icons.shopping_cart_outlined, label: 'Giỏ hàng'),
    NavItem(icon: Icons.receipt_long_outlined, label: 'Đơn hàng'),
    NavItem(icon: Icons.person_outline, label: 'Tôi'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            // Chia đều không gian cho 5 mục để responsive trên mọi bề ngang.
            children: List.generate(items.length, (index) {
              return Expanded(child: _buildItem(context, index));
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final palette = context.palette;
    final item = items[index];
    final isActive = index == currentIndex;
    final color = isActive ? palette.primary : palette.textHint;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Cho phép chạm cả vùng trống.
      onTap: () => onTap?.call(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(context, item.icon, color, index),
          const SizedBox(height: 4),
          Text(item.label, style: AppTextStyles.navLabel.copyWith(color: color)),
        ],
      ),
    );
  }

  /// Icon kèm badge (chỉ cho mục Giỏ hàng khi có món).
  Widget _buildIcon(BuildContext context, IconData icon, Color color, int index) {
    final showBadge = index == _cartIndex && cartCount > 0;
    if (!showBadge) return Icon(icon, color: color, size: 24);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color, size: 24),
        Positioned(
          right: -8,
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            constraints: const BoxConstraints(minWidth: 16),
            decoration: BoxDecoration(
              color: context.palette.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              cartCount > 9 ? '9+' : '$cartCount',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
