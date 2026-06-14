import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

/// Ô tìm kiếm bo tròn với icon kính lúp.
class SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    this.hintText = 'Tìm món ăn...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.body.copyWith(color: palette.textPrimary),
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          prefixIcon: Icon(Icons.search, color: palette.textHint, size: 20),
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(color: palette.textHint),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
