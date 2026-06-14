import 'review.dart';

/// Mô hình dữ liệu cho một món ăn.
class FoodItem {
  final String id; // Khóa định danh - dùng cho giỏ hàng & yêu thích.
  final String name;
  final int calories;
  final int price; // Đơn vị: VNĐ
  final String? imageUrl; // Null => hiển thị placeholder.

  // Các trường mở rộng dùng cho màn hình chi tiết.
  final double rating;
  final int reviewCount;
  final int protein; // gram
  final int carbs; // gram
  final int fat; // gram
  final String description;
  final List<String> ingredients;
  final List<Review> reviews;
  final String category;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.price,
    this.imageUrl,
    this.rating = 4.8,
    this.reviewCount = 128,
    this.protein = 32,
    this.carbs = 28,
    this.fat = 12,
    this.description = '',
    this.ingredients = const [],
    this.reviews = const [],
    this.category = 'Tất cả',
  });
}
