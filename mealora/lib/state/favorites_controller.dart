import 'package:flutter/foundation.dart';
import '../data/sample_data.dart';
import '../models/food_item.dart';

/// Quản lý danh sách món yêu thích (theo id) - [ChangeNotifier] singleton.
class FavoritesController extends ChangeNotifier {
  FavoritesController._();
  static final FavoritesController instance = FavoritesController._();

  final Set<String> _favoriteIds = {'f1', 'f3'}; // Một vài món sẵn cho demo.

  bool isFavorite(String id) => _favoriteIds.contains(id);

  int get count => _favoriteIds.length;

  /// Danh sách món yêu thích (đã giải mã từ id).
  List<FoodItem> get favorites => SampleData.foods
      .where((f) => _favoriteIds.contains(f.id))
      .toList(growable: false);

  void toggle(String id) {
    if (!_favoriteIds.remove(id)) _favoriteIds.add(id);
    notifyListeners();
  }

  /// Thêm vào yêu thích (không bỏ nếu đã có) - dùng khi vuốt thích ở Khám phá.
  void add(String id) {
    if (_favoriteIds.add(id)) notifyListeners();
  }
}
