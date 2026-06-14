import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

/// Header dùng chung: nút back bên trái, tiêu đề căn giữa, action tùy chọn.
/// Nền trắng/surface với chiều cao cố định như thiết kế (96px gồm status bar).
class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget? action;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      color: palette.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Tiêu đề luôn căn giữa.
              Text(
                title,
                style: AppTextStyles.appBarTitle
                    .copyWith(color: palette.textPrimary),
              ),
              if (showBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: palette.textPrimary, size: 20),
                  ),
                ),
              if (action != null)
                Align(alignment: Alignment.centerRight, child: action!),
            ],
          ),
        ),
      ),
    );
  }
}
