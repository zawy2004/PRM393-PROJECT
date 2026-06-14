import 'package:flutter/material.dart';

/// Các kiểu chữ dùng chung (chỉ định nghĩa size + weight, KHÔNG gán màu).
///
/// Màu được áp ở widget bằng `.copyWith(color: context.palette.xxx)` để tự
/// thích ứng Light/Dark mode. Thiết kế dùng font "Inter" - thêm font vào
/// pubspec rồi đổi [fontFamily] = 'Inter' để khớp 100%.
class AppTextStyles {
  AppTextStyles._();

  static const String? fontFamily = null; // Đổi thành 'Inter' khi đã thêm font.

  static TextStyle _base(double size, FontWeight weight) => TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: 1.2,
      );

  // Tiêu đề lớn (Splash, Login).
  static TextStyle get displayLarge => _base(36, FontWeight.bold);
  static TextStyle get headline => _base(28, FontWeight.bold);

  // Header & tiêu đề.
  static TextStyle get greeting => _base(22, FontWeight.bold);
  static TextStyle get titleLarge => _base(24, FontWeight.bold);
  static TextStyle get appBarTitle => _base(20, FontWeight.w600);
  static TextStyle get sectionTitle => _base(18, FontWeight.w600);
  static TextStyle get subtitle => _base(16, FontWeight.w600);

  // Nội dung.
  static TextStyle get bodyLarge => _base(15, FontWeight.normal);
  static TextStyle get body => _base(14, FontWeight.normal);
  static TextStyle get bodySmall => _base(13, FontWeight.normal);
  static TextStyle get caption => _base(12, FontWeight.normal);
  static TextStyle get tiny => _base(11, FontWeight.normal);

  // Nhấn mạnh.
  static TextStyle get labelMedium => _base(14, FontWeight.w500);
  static TextStyle get semibold15 => _base(15, FontWeight.w600);
  static TextStyle get semibold14 => _base(14, FontWeight.w600);
  static TextStyle get button => _base(16, FontWeight.w600);
  static TextStyle get price => _base(15, FontWeight.bold);
  static TextStyle get priceLarge => _base(22, FontWeight.bold);

  // Thanh điều hướng.
  static TextStyle get navLabel => _base(10, FontWeight.w500);
}
