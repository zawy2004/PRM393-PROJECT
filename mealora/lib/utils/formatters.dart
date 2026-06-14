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
}
