import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

/// Hiển thị ảnh món ăn, tự rơi về placeholder màu xanh nhạt khi chưa có ảnh
/// hoặc khi tải lỗi. Dùng chung cho Card, Cart, Hero image...
class FoodImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final IconData placeholderIcon;

  const FoodImage({
    super.key,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.restaurant_menu,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder(context);
    }
    return Image.network(
      imageUrl!,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    final palette = context.palette;
    return Container(
      color: palette.imagePlaceholder,
      alignment: Alignment.center,
      child: Icon(placeholderIcon,
          color: palette.primary.withValues(alpha: 0.4), size: 32),
    );
  }
}
