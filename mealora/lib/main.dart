import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đọc cấu hình Firebase từ android/app/google-services.json.
  await Firebase.initializeApp();

  // Mở DB. SplashScreen sẽ tự thử khôi phục phiên đăng nhập (nếu có) và
  // load giỏ hàng/yêu thích đúng user qua SessionController.restoreSession().
  await DatabaseHelper.instance.database;

  runApp(const MealoraApp());
}

class MealoraApp extends StatelessWidget {
  const MealoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild toàn app khi người dùng đổi Light/Dark mode.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Mealora',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
