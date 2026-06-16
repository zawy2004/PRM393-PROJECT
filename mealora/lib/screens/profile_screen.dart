import 'package:flutter/material.dart';
import '../state/favorites_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_controller.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

/// Màn hình hồ sơ: header xanh với avatar, thẻ thống kê, danh sách menu
/// (gồm công tắc Chế độ tối) và nút đăng xuất.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildStats(context),
          const SizedBox(height: 16),
          _buildMenu(context),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildLogout(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Header nền xanh chứa avatar + tên + email.
  Widget _buildHeader(BuildContext context) {
    final primary = context.palette.primary;
    return Container(
      width: double.infinity,
      color: primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 28),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Text('L',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Text('clone',
                  style:
                      AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 22)),
              const SizedBox(height: 4),
              Text('clone@email.com',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: Colors.white.withValues(alpha: 0.85))),
            ],
          ),
        ),
      ),
    );
  }

  /// Thẻ 3 chỉ số: đơn hàng, điểm thưởng, đánh giá.
  Widget _buildStats(BuildContext context) {
    final palette = context.palette;
    // Số yêu thích cập nhật trực tiếp theo FavoritesController.
    return ListenableBuilder(
      listenable: FavoritesController.instance,
      builder: (context, _) {
        final stats = [
          ('24', 'Đơn hàng'),
          ('${FavoritesController.instance.count}', 'Yêu thích'),
          ('4.9', 'Đánh giá'),
        ];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              for (int i = 0; i < stats.length; i++) ...[
                Expanded(
                  child: Column(
                    children: [
                      Text(stats[i].$1,
                          style: AppTextStyles.titleLarge
                              .copyWith(color: palette.primary, fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(stats[i].$2,
                          style: AppTextStyles.caption
                              .copyWith(color: palette.textSecondary)),
                    ],
                  ),
                ),
                if (i != stats.length - 1)
                  Container(width: 1, height: 36, color: palette.border),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Thẻ danh sách menu.
  Widget _buildMenu(BuildContext context) {
    final palette = context.palette;
    final items = <Widget>[
      _menuRow(context, Icons.person_outline, 'Thông tin cá nhân'),
      _menuRow(context, Icons.favorite_border, 'Món yêu thích', onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
      }),
      _menuRow(context, Icons.location_on_outlined, 'Địa chỉ giao hàng'),
      _menuRow(context, Icons.payment_outlined, 'Phương thức thanh toán'),
      _menuRow(context, Icons.card_membership_outlined, 'Gói đăng ký của tôi'),
      _buildDarkModeRow(context), // Hàng có công tắc chế độ tối.
      _menuRow(context, Icons.language_outlined, 'Ngôn ngữ'),
      _menuRow(context, Icons.help_outline, 'Trợ giúp & hỗ trợ'),
      _menuRow(context, Icons.description_outlined, 'Điều khoản & chính sách'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1)
              Divider(height: 1, indent: 56, endIndent: 16, color: palette.border),
          ],
        ],
      ),
    );
  }

  Widget _menuRow(BuildContext context, IconData icon, String label,
      {VoidCallback? onTap}) {
    final palette = context.palette;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22, color: palette.textSecondary),
      title: Text(label,
          style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary)),
      trailing:
          Icon(Icons.chevron_right, color: palette.textHint, size: 22),
    );
  }

  /// Hàng "Chế độ tối" với công tắc - lắng nghe ThemeController để đồng bộ.
  Widget _buildDarkModeRow(BuildContext context) {
    final palette = context.palette;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return ListTile(
          leading: Icon(Icons.dark_mode_outlined,
              size: 22, color: palette.textSecondary),
          title: Text('Chế độ tối',
              style:
                  AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary)),
          trailing: Switch(
            value: mode == ThemeMode.dark,
            activeTrackColor: palette.primary,
            onChanged: (_) => ThemeController.toggle(),
          ),
        );
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout, size: 20, color: Color(0xFFEF4444)),
        label: Text('Đăng xuất',
            style: AppTextStyles.button.copyWith(
                color: const Color(0xFFEF4444), fontSize: 15)),
        style: OutlinedButton.styleFrom(
          backgroundColor: palette.surface,
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
