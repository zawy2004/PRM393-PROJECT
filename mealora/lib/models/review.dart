/// Đánh giá của người dùng cho một món ăn.
class Review {
  final String author;
  final String initials; // Chữ cái đầu hiển thị trên avatar.
  final double rating;
  final String comment;
  final String time;

  const Review({
    required this.author,
    required this.initials,
    required this.rating,
    required this.comment,
    required this.time,
  });
}
