import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

/// Nút bấm chính (nền xanh, chữ trắng) dùng xuyên suốt app.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 52,
    this.radius = 14,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.palette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(label, style: AppTextStyles.button.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// Nút phụ dạng viền (outline) - dùng cho "Google", "Đặt lại"...
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final double height;

  const OutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: palette.surface,
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(
              label,
              style: AppTextStyles.labelMedium
                  .copyWith(color: palette.textPrimary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
