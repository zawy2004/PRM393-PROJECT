import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../utils/formatters.dart';
import 'food_image.dart';

/// Thẻ món ăn dùng trong bộ vuốt (Khám phá): ảnh nền + lớp phủ gradient +
/// thông tin món (tên, sao đánh giá, calo, giá, tag danh mục).
class FoodSwipeCard extends StatelessWidget {
  final FoodItem item;

  const FoodSwipeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền (placeholder nếu chưa có imageUrl).
          FoodImage(imageUrl: item.imageUrl),
          // Lớp phủ tối dần để chữ dễ đọc.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 1.0],
                colors: [Colors.transparent, Color(0xE0000000)],
              ),
            ),
          ),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Sao đánh giá.
          Row(
            children: [
              _buildStars(item.rating),
              const SizedBox(width: 6),
              Text(
                item.rating.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Calo + giá.
          Row(
            children: [
              const Icon(Icons.local_fire_department,
                  color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                '${item.calories} kcal',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(width: 12),
              Text(
                Formatters.price(item.price),
                style: const TextStyle(
                  color: Color(0xFF2EB878),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Tag danh mục + nhóm dinh dưỡng.
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _tag(item.category),
              _tag('${item.protein}g protein'),
              _tag('${item.carbs}g carbs'),
            ],
          ),
        ],
      ),
    );
  }

  /// Hàng 5 sao đặc/rỗng theo rating.
  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
          color: const Color(0xFFFFD700),
          size: 18,
        );
      }),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
