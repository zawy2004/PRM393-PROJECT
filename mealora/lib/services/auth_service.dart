import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thông tin tài khoản Google sau khi xác thực thành công.
class GoogleAuthResult {
  final String email;
  final String displayName;
  const GoogleAuthResult({required this.email, required this.displayName});
}

/// Bọc luồng đăng nhập Google qua Firebase Auth.
///
/// YÊU CẦU CẤU HÌNH trên Firebase Console (project mealora-4dd12) trước khi dùng:
/// 1. Project Settings > Your apps > Android app > thêm SHA-1 của debug keystore.
/// 2. Authentication > Sign-in method > bật provider "Google".
/// Thiếu 1 trong 2 bước trên, [signInWithGoogle] sẽ ném lỗi DEVELOPER_ERROR / 10.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize();
    _initialized = true;
  }

  /// Mở luồng chọn tài khoản Google, đổi idToken sang Firebase credential,
  /// rồi đăng nhập Firebase Auth. Ném [GoogleSignInException] nếu người dùng
  /// hủy hoặc xác thực Google thất bại.
  Future<GoogleAuthResult> signInWithGoogle() async {
    await _ensureInitialized();

    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final email = userCredential.user?.email ?? account.email;
    final displayName = userCredential.user?.displayName ??
        account.displayName ??
        email.split('@').first;

    return GoogleAuthResult(email: email, displayName: displayName);
  }

  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    if (_initialized) {
      await GoogleSignIn.instance.signOut();
    }
  }
}
