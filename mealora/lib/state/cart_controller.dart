import 'package:flutter/foundation.dart';
import '../data/sample_data.dart';
import '../models/food_item.dart';

/// Quản lý trạng thái giỏ hàng dùng chung toàn app.
///
/// Là [ChangeNotifier] singleton (giống [ThemeController]); widget lắng nghe
/// bằng `ListenableBuilder(listenable: CartController.instance, ...)`.
class CartController extends ChangeNotifier {
  CartController._();
  static final CartController instance = CartController._();

  // Khởi tạo sẵn vài món cho demo.
  final List<CartLine> _lines = [
    CartLine(item: SampleData.foods[0], quantity: 2),
    CartLine(item: SampleData.foods[1]),
    CartLine(item: SampleData.foods[2]),
  ];

  List<CartLine> get lines => List.unmodifiable(_lines);

  bool get isEmpty => _lines.isEmpty;

  /// Tổng số lượng món (dùng cho badge trên thanh điều hướng).
  int get itemCount => _lines.fold(0, (sum, l) => sum + l.quantity);

  /// Tạm tính (chưa giảm giá / phí ship).
  int get subtotal => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  /// Thêm món vào giỏ - gộp số lượng nếu đã tồn tại.
  void add(FoodItem item, {int quantity = 1}) {
    final existing = _lines.where((l) => l.item.id == item.id);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _lines.add(CartLine(item: item, quantity: quantity));
    }
    notifyListeners();
  }

  /// Tăng/giảm số lượng; tự xóa dòng khi về 0.
  void changeQuantity(CartLine line, int delta) {
    line.quantity += delta;
    if (line.quantity <= 0) _lines.remove(line);
    notifyListeners();
  }

  void remove(CartLine line) {
    _lines.remove(line);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
