import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'food_image.dart';

/// Thẻ hiển thị một món ăn: ảnh + tên + calo + giá + nút thêm vào giỏ.
class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const FoodCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh món ăn (placeholder nếu chưa có imageUrl).
            AspectRatio(
              aspectRatio: 169 / 120,
              child: FoodImage(imageUrl: item.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.semibold14
                        .copyWith(color: palette.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.calories} kcal',
                    style:
                        AppTextStyles.caption.copyWith(color: palette.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          Formatters.price(item.price),
                          style: AppTextStyles.price
                              .copyWith(color: palette.primary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _AddButton(onTap: onAdd),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút tròn xanh dấu "+" để thêm món vào giỏ.
class _AddButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: context.palette.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 18),
      ),
    );
  }
}
