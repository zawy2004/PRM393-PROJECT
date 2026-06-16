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

  /// Serialise các trường cơ bản vào SQLite (ingredients và reviews lưu bảng riêng).
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'price': price,
        'image_url': imageUrl,
        'rating': rating,
        'review_count': reviewCount,
      };

  FoodItem copyWithIngredients(List<String> ingredients) => FoodItem(
        id: id,
        name: name,
        calories: calories,
        price: price,
        imageUrl: imageUrl,
        rating: rating,
        reviewCount: reviewCount,
        protein: protein,
        carbs: carbs,
        fat: fat,
        description: description,
        ingredients: ingredients,
        reviews: reviews,
        category: category,
      );

  factory FoodItem.fromMap(Map<String, dynamic> map) => FoodItem(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String? ?? 'Tất cả',
        description: map['description'] as String? ?? '',
        calories: map['calories'] as int? ?? 0,
        protein: map['protein'] as int? ?? 0,
        carbs: map['carbs'] as int? ?? 0,
        fat: map['fat'] as int? ?? 0,
        price: map['price'] as int? ?? 0,
        imageUrl: map['image_url'] as String?,
        rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: map['review_count'] as int? ?? 0,
      );
}
