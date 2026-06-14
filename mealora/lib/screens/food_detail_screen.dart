import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/review.dart';
import '../state/favorites_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/food_image.dart';
import '../widgets/primary_button.dart';

/// Màn hình chi tiết món ăn: ảnh hero, thông tin dinh dưỡng, mô tả,
/// nguyên liệu và thanh giá + nút "Thêm vào giỏ" cố định dưới cùng.
class FoodDetailScreen extends StatefulWidget {
  final FoodItem item;
  final ValueChanged<FoodItem>? onAddToCart;

  const FoodDetailScreen({super.key, required this.item, this.onAddToCart});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final _favorites = FavoritesController.instance;

  void _addToCart() {
    widget.onAddToCart?.call(widget.item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm "${widget.item.name}" vào giỏ'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final item = widget.item;

    return Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          // Nội dung cuộn.
          CustomScrollView(
            slivers: [
              _buildHeroAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: AppTextStyles.titleLarge
                              .copyWith(color: palette.textPrimary)),
                      const SizedBox(height: 8),
                      // Đánh giá.
                      Row(
                        children: [
                          Icon(Icons.star, color: palette.primary, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${item.rating}  (${item.reviewCount} đánh giá)',
                            style: AppTextStyles.body
                                .copyWith(color: palette.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildNutritionRow(),
                      const SizedBox(height: 24),
                      Text('Mô tả',
                          style: AppTextStyles.subtitle
                              .copyWith(color: palette.textPrimary)),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: AppTextStyles.body.copyWith(
                            color: palette.textSecondary, height: 1.6),
                      ),
                      const SizedBox(height: 24),
                      Text('Nguyên liệu',
                          style: AppTextStyles.subtitle
                              .copyWith(color: palette.textPrimary)),
                      const SizedBox(height: 8),
                      ...item.ingredients.map(_buildIngredient),
                      if (item.reviews.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text('Đánh giá (${item.reviewCount})',
                            style: AppTextStyles.subtitle
                                .copyWith(color: palette.textPrimary)),
                        const SizedBox(height: 12),
                        ...item.reviews.map(_buildReview),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Thanh giá + nút cố định dưới cùng.
          Align(alignment: Alignment.bottomCenter, child: _buildBottomBar()),
        ],
      ),
    );
  }

  /// AppBar co giãn chứa ảnh hero + nút back/favorite nổi lên trên.
  Widget _buildHeroAppBar() {
    final palette = context.palette;
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: palette.surface,
      foregroundColor: palette.textPrimary,
      leading: _circleButton(Icons.arrow_back_ios_new,
          () => Navigator.of(context).maybePop()),
      actions: [
        // Nút yêu thích đồng bộ với FavoritesController.
        ListenableBuilder(
          listenable: _favorites,
          builder: (context, _) {
            final fav = _favorites.isFavorite(widget.item.id);
            return _circleButton(
              fav ? Icons.favorite : Icons.favorite_border,
              () => _favorites.toggle(widget.item.id),
              iconColor: fav ? Colors.red : palette.textPrimary,
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: FoodImage(imageUrl: widget.item.imageUrl),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color? iconColor}) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: palette.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 18, color: iconColor ?? palette.textPrimary),
          ),
        ),
      ),
    );
  }

  /// Hàng 4 ô dinh dưỡng: Calories, Protein, Carbs, Fat.
  Widget _buildNutritionRow() {
    final item = widget.item;
    final boxes = [
      ('${item.calories} kcal', 'Calories'),
      ('${item.protein}g', 'Protein'),
      ('${item.carbs}g', 'Carbs'),
      ('${item.fat}g', 'Fat'),
    ];
    return Row(
      children: [
        for (int i = 0; i < boxes.length; i++) ...[
          Expanded(child: _nutritionBox(boxes[i].$1, boxes[i].$2)),
          if (i != boxes.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }

  Widget _nutritionBox(String value, String label) {
    final palette = context.palette;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: palette.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: AppTextStyles.semibold14.copyWith(color: palette.primary)),
          const SizedBox(height: 4),
          Text(label,
              style:
                  AppTextStyles.tiny.copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildIngredient(String name) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ',
              style: AppTextStyles.body.copyWith(color: palette.textSecondary)),
          Expanded(
            child: Text(name,
                style:
                    AppTextStyles.body.copyWith(color: palette.textSecondary)),
          ),
        ],
      ),
    );
  }

  /// Một dòng đánh giá: avatar chữ cái, tên, sao và bình luận.
  Widget _buildReview(Review review) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: palette.surfaceVariant,
            child: Text(review.initials,
                style: AppTextStyles.semibold14
                    .copyWith(color: palette.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.author,
                        style: AppTextStyles.semibold14
                            .copyWith(color: palette.textPrimary)),
                    // Sao đánh giá.
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: palette.primary,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review.comment,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: palette.textSecondary, height: 1.4)),
                const SizedBox(height: 4),
                Text(review.time,
                    style: AppTextStyles.tiny.copyWith(color: palette.textHint)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Thanh dưới: giá bên trái, nút "Thêm vào giỏ" bên phải.
  Widget _buildBottomBar() {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Giá',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: palette.textSecondary)),
                const SizedBox(height: 2),
                Text(Formatters.price(widget.item.price),
                    style: AppTextStyles.priceLarge
                        .copyWith(color: palette.textPrimary)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                label: 'Thêm vào giỏ',
                icon: Icons.shopping_cart_outlined,
                onPressed: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
