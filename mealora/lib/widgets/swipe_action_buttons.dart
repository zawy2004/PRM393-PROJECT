import 'package:flutter/material.dart';

/// Hàng nút điều khiển vuốt: quay lại, bỏ qua, siêu thích, thích.
/// Tương ứng các thao tác undo / left / top / right của CardSwiper.
class SwipeActionButtons extends StatelessWidget {
  final VoidCallback onRewind;
  final VoidCallback onDislike;
  final VoidCallback onLike;
  final VoidCallback onSuperLike;

  const SwipeActionButtons({
    super.key,
    required this.onRewind,
    required this.onDislike,
    required this.onLike,
    required this.onSuperLike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          onTap: onRewind,
          icon: Icons.replay_rounded,
          color: const Color(0xFFFFC107), // vàng
          size: 52,
          iconSize: 26,
        ),
        const SizedBox(width: 16),
        _ActionButton(
          onTap: onDislike,
          icon: Icons.close_rounded,
          color: const Color(0xFFF44336), // đỏ
          size: 64,
          iconSize: 34,
        ),
        const SizedBox(width: 16),
        _ActionButton(
          onTap: onSuperLike,
          icon: Icons.star_rounded,
          color: const Color(0xFF2196F3), // xanh dương
          size: 52,
          iconSize: 26,
        ),
        const SizedBox(width: 16),
        _ActionButton(
          onTap: onLike,
          icon: Icons.favorite_rounded,
          color: const Color(0xFF2EB878), // xanh lá thương hiệu
          size: 64,
          iconSize: 34,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  const _ActionButton({
    required this.onTap,
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
