import '../models/user.dart';
import 'cart_controller.dart';
import 'favorites_controller.dart';

/// Quản lý phiên đăng nhập hiện tại.
/// Sau khi login/register thành công, gọi [startSession] để cập nhật
/// toàn bộ controller sang đúng userId của user.
class SessionController {
  SessionController._();
  static final SessionController instance = SessionController._();

  String _userId = 'user_1'; // Giá trị mặc định trước khi login.
  User? _currentUser;

  String get userId => _userId;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Gọi sau khi xác thực thành công; re-init giỏ hàng & yêu thích theo user.
  Future<void> startSession(User user) async {
    _userId = user.id;
    _currentUser = user;
    await Future.wait([
      CartController.instance.init(_userId),
      FavoritesController.instance.init(_userId),
    ]);
  }

  void logout() {
    CartController.instance.clear();
    _userId = 'user_1';
    _currentUser = null;
  }
}
