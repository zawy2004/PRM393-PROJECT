import 'package:flutter/material.dart';
import 'app_palette.dart';
import 'app_text_styles.dart';

/// Tạo [ThemeData] cho chế độ sáng & tối, đính kèm [AppPalette] làm extension.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(AppPalette.light, Brightness.light);
  static ThemeData dark() => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: brightness,
    ).copyWith(
      surface: palette.background,
      primary: palette.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: palette.background,
      colorScheme: colorScheme,
      // Đăng ký bảng màu tùy biến để truy cập qua context.palette.
      extensions: [palette],
    );
  }
}
