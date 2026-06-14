import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import 'login_screen.dart';

/// Màn hình khởi động: nền xanh, logo + tên app + thanh loading.
/// Tự chuyển sang Login sau 2.5 giây.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animation cho thanh loading chạy từ 0 -> 1.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    // Điều hướng sang Login khi loading xong.
    Timer(const Duration(milliseconds: 2500), _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.palette.primary;
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (placeholder hình tròn với icon).
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 32),
            Text(
              'MealPrep',
              style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Healthy meals, delivered weekly',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 64),
            // Thanh loading.
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => LinearProgressIndicator(
                    value: _controller.value,
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
