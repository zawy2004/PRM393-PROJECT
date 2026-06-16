/// Đánh giá của người dùng cho một món ăn.
class Review {
  final int? id;
  final String? mealId;
  final String author;
  final String initials; // Chữ cái đầu hiển thị trên avatar.
  final double rating;
  final String comment;
  final String time;

  const Review({
    this.id,
    this.mealId,
    required this.author,
    required this.initials,
    required this.rating,
    required this.comment,
    required this.time,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'meal_id': mealId,
        'author': author,
        'initials': initials,
        'rating': rating,
        'comment': comment,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };

  factory Review.fromMap(Map<String, dynamic> map) {
    final createdAt = map['created_at'] as int?;
    return Review(
      id: map['id'] as int?,
      mealId: map['meal_id'] as String?,
      author: map['author'] as String,
      initials: map['initials'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      time: createdAt != null
          ? _relativeTime(DateTime.fromMillisecondsSinceEpoch(createdAt))
          : (map['time'] as String? ?? ''),
    );
  }

  static String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 7) return '${diff.inDays ~/ 7} tuần trước';
    if (diff.inDays >= 1) return '${diff.inDays} ngày trước';
    if (diff.inHours >= 1) return '${diff.inHours} giờ trước';
    return '${diff.inMinutes} phút trước';
  }
}
