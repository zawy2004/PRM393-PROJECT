import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'screens/splash_screen.dart';
import 'state/cart_controller.dart';
import 'state/favorites_controller.dart';
import 'state/session_controller.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mở DB, sau đó pre-load giỏ hàng & yêu thích cho phiên guest mặc định.
  // Sau khi login thật, SessionController.startSession() sẽ re-init sang đúng user.
  await DatabaseHelper.instance.database;
  final guestId = SessionController.instance.userId;
  await Future.wait([
    CartController.instance.init(guestId),
    FavoritesController.instance.init(guestId),
  ]);

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
