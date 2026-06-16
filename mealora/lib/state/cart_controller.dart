import 'package:flutter/foundation.dart';
import '../data/sample_data.dart';
import '../database/database_service.dart';
import '../models/food_item.dart';

/// Quản lý trạng thái giỏ hàng - [ChangeNotifier] singleton.
/// Trạng thái được đồng bộ với SQLite thông qua [DatabaseService].
class CartController extends ChangeNotifier {
  CartController._();
  static final CartController instance = CartController._();

  String _userId = 'user_1';

  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  bool get isEmpty => _lines.isEmpty;

  /// Tổng số lượng món (dùng cho badge trên thanh điều hướng).
  int get itemCount => _lines.fold(0, (sum, l) => sum + l.quantity);

  /// Tạm tính (chưa giảm giá / phí ship).
  int get subtotal => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  /// Gọi một lần khi khởi động app để load giỏ hàng từ DB.
  Future<void> init(String userId) async {
    _userId = userId;
    final rows = await DatabaseService.instance.getCartItems(userId);
    _lines.clear();
    for (final row in rows) {
      final item = SampleData.findById(row.mealId);
      if (item != null) {
        _lines.add(CartLine(item: item, quantity: row.quantity));
      }
    }
    notifyListeners();
  }

  /// Thêm món vào giỏ - gộp số lượng nếu đã tồn tại.
  void add(FoodItem item, {int quantity = 1}) {
    final existing = _lines.where((l) => l.item.id == item.id);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _lines.add(CartLine(item: item, quantity: quantity));
    }
    notifyListeners();
    _persist(item.id);
  }

  /// Tăng/giảm số lượng; tự xóa dòng khi về 0.
  void changeQuantity(CartLine line, int delta) {
    line.quantity += delta;
    if (line.quantity <= 0) {
      _lines.remove(line);
      DatabaseService.instance.removeCartItem(_userId, line.item.id);
    } else {
      DatabaseService.instance
          .upsertCartItem(_userId, line.item.id, line.quantity);
    }
    notifyListeners();
  }

  void remove(CartLine line) {
    _lines.remove(line);
    notifyListeners();
    DatabaseService.instance.removeCartItem(_userId, line.item.id);
  }

  void clear() {
    _lines.clear();
    notifyListeners();
    DatabaseService.instance.clearCart(_userId);
  }

  void _persist(String mealId) {
    final line = _lines.firstWhere((l) => l.item.id == mealId);
    DatabaseService.instance.upsertCartItem(_userId, mealId, line.quantity);
  }
}
