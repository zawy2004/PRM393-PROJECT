import 'package:flutter/foundation.dart';
import '../data/sample_data.dart';
import '../database/database_service.dart';
import '../models/food_item.dart';

/// Quản lý danh sách món yêu thích - [ChangeNotifier] singleton.
/// Trạng thái được đồng bộ với SQLite thông qua [DatabaseService].
class FavoritesController extends ChangeNotifier {
  FavoritesController._();
  static final FavoritesController instance = FavoritesController._();

  // ID người dùng hiện tại; được gán khi gọi init().
  String _userId = 'user_1';

  final Set<String> _favoriteIds = {};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  int get count => _favoriteIds.length;

  List<FoodItem> get favorites => SampleData.foods
      .where((f) => _favoriteIds.contains(f.id))
      .toList(growable: false);

  /// Gọi một lần khi khởi động app để load dữ liệu từ DB.
  Future<void> init(String userId) async {
    _userId = userId;
    final ids = await DatabaseService.instance.getFavoriteIds(userId);
    _favoriteIds
      ..clear()
      ..addAll(ids);
    notifyListeners();
  }

  void toggle(String id) {
    if (!_favoriteIds.remove(id)) {
      _favoriteIds.add(id);
    }
    notifyListeners();
    DatabaseService.instance.toggleFavorite(_userId, id);
  }

  /// Thêm vào yêu thích (không bỏ nếu đã có) - dùng khi vuốt thích ở Khám phá.
  void add(String id) {
    if (_favoriteIds.add(id)) {
      notifyListeners();
      DatabaseService.instance.addFavorite(_userId, id);
    }
  }
}
