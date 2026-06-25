import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_service.dart';
import '../models/user.dart';
import 'cart_controller.dart';
import 'favorites_controller.dart';

/// Quản lý phiên đăng nhập hiện tại.
///
/// Sau khi login/register/Google sign-in thành công, gọi [startSession] để
/// cập nhật toàn bộ controller sang đúng userId của user, đồng thời lưu
/// userId vào SharedPreferences để [restoreSession] có thể tự đăng nhập lại
/// ở lần mở app kế tiếp (cho đến khi người dùng [logout]).
class SessionController {
  SessionController._();
  static final SessionController instance = SessionController._();

  static const _prefsKey = 'session_user_id';

  String _userId = 'user_1'; // Giá trị mặc định trước khi login.
  User? _currentUser;

  String get userId => _userId;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Gọi sau khi xác thực thành công; re-init giỏ hàng & yêu thích theo user
  /// và ghi nhớ phiên để lần mở app sau không cần đăng nhập lại.
  Future<void> startSession(User user) async {
    _userId = user.id;
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, user.id);
    await Future.wait([
      CartController.instance.init(_userId),
      FavoritesController.instance.init(_userId),
    ]);
  }

  /// Gọi khi khởi động app (từ SplashScreen). Nếu có phiên đã lưu và user vẫn
  /// còn tồn tại trong DB thì tự đăng nhập lại, trả về true. Ngược lại trả về
  /// false để app điều hướng tới màn Login.
  Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_prefsKey);
    if (savedId == null) return false;

    final user = await DatabaseService.instance.getUserById(savedId);
    if (user == null) {
      await prefs.remove(_prefsKey);
      return false;
    }

    _userId = user.id;
    _currentUser = user;
    await Future.wait([
      CartController.instance.init(_userId),
      FavoritesController.instance.init(_userId),
    ]);
    return true;
  }

  /// Xóa phiên đã lưu; lần mở app sau sẽ phải đăng nhập lại.
  Future<void> logout() async {
    CartController.instance.clear();
    _userId = 'user_1';
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
