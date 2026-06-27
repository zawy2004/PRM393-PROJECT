/// Các hàm định dạng dùng chung trong app.
class Formatters {
  Formatters._();

  /// Định dạng số tiền kiểu "65.000đ".
  static String price(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      // Chèn dấu chấm ngăn cách mỗi 3 chữ số tính từ phải sang.
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return '${buffer.toString()}đ';
  }

  static const List<String> _weekdays = [
    'Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7',
  ];

  /// Định dạng "26/06/2026".
  static String shortDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  /// Định dạng "Thứ 6, 26/06/2026".
  static String weekdayDate(DateTime dt) =>
      '${_weekdays[dt.weekday % 7]}, ${shortDate(dt)}';
}
