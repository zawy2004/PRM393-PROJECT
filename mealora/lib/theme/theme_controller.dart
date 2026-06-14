import 'package:flutter/material.dart';

/// Quản lý chế độ sáng/tối của ứng dụng.
///
/// Dùng [ValueNotifier] đơn giản (không cần package state-management ngoài).
/// Bọc MaterialApp bằng `ValueListenableBuilder` để rebuild khi đổi theme.
class ThemeController {
  ThemeController._();

  /// Instance dùng chung toàn app.
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Đảo trạng thái sáng <-> tối.
  static void toggle() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  /// True nếu đang ở chế độ tối.
  static bool get isDark => themeMode.value == ThemeMode.dark;
}
