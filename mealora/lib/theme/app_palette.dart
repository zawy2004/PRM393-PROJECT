import 'package:flutter/material.dart';

/// Bảng màu ngữ nghĩa (semantic) của ứng dụng.
///
/// Được đăng ký như một [ThemeExtension] nên có thể truy cập ở bất kỳ widget
/// nào qua `context.palette` và tự đổi theo Light/Dark mode.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Màu chủ đạo (xanh lá) - giữ nguyên ở cả 2 chế độ để đồng nhất thương hiệu.
  final Color primary;

  /// Nền chính của màn hình.
  final Color background;

  /// Nền thẻ / thanh / ô nhập.
  final Color surface;

  /// Nền phụ (ô tìm kiếm, nút -, box dinh dưỡng...).
  final Color surfaceVariant;

  /// Nền placeholder cho ảnh món ăn.
  final Color imagePlaceholder;

  /// Màu chữ chính.
  final Color textPrimary;

  /// Màu chữ phụ (xám).
  final Color textSecondary;

  /// Màu chữ mờ / placeholder / icon inactive.
  final Color textHint;

  /// Màu viền.
  final Color border;

  const AppPalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.imagePlaceholder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
  });

  /// Bảng màu chế độ Sáng - lấy trực tiếp từ thiết kế Figma.
  static const AppPalette light = AppPalette(
    primary: Color(0xFF2EB878),
    background: Color(0xFFFAFAF5),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFFAFAF5),
    imagePlaceholder: Color(0xFFEDF2E5),
    textPrimary: Color(0xFF1F1F24),
    textSecondary: Color(0xFF8C8C94),
    textHint: Color(0xFFBFBFC4),
    border: Color(0xFFEBEBED),
  );

  /// Bảng màu chế độ Tối - được điều chỉnh đồng bộ với tông xanh thương hiệu.
  static const AppPalette dark = AppPalette(
    primary: Color(0xFF2EB878),
    background: Color(0xFF121317),
    surface: Color(0xFF1E1F25),
    surfaceVariant: Color(0xFF2A2B33),
    imagePlaceholder: Color(0xFF2A3327),
    textPrimary: Color(0xFFF5F5F7),
    textSecondary: Color(0xFF9A9AA2),
    textHint: Color(0xFF6E6E76),
    border: Color(0xFF2E2F37),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? imagePlaceholder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? border,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      border: border ?? this.border,
    );
  }

  /// Nội suy màu khi chuyển theme (tạo hiệu ứng mượt khi đổi sáng/tối).
  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      imagePlaceholder:
          Color.lerp(imagePlaceholder, other.imagePlaceholder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

/// Cú pháp tiện lợi: `context.palette.primary` thay cho
/// `Theme.of(context).extension<AppPalette>()!.primary`.
extension PaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
