import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

/// Màn hình thông báo: danh sách thông báo, chấm xanh đánh dấu chưa đọc.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<AppNotification> _notifications = SampleData.notifications;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.surface,
      body: Column(
        children: [
          const AppHeader(title: 'Thông báo'),
          Expanded(
            child: ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 70,
                color: palette.border,
              ),
              itemBuilder: (context, index) =>
                  _buildItem(context, _notifications[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, AppNotification n) {
    final palette = context.palette;
    return Container(
      color: n.unread
          ? palette.primary.withValues(alpha: 0.04)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon tròn.
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: palette.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(n.icon, size: 20, color: palette.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(n.title,
                          style: AppTextStyles.semibold14
                              .copyWith(color: palette.textPrimary)),
                    ),
                    // Chấm xanh chưa đọc.
                    if (n.unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: palette.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(n.description,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: palette.textSecondary, height: 1.4)),
                const SizedBox(height: 6),
                Text(n.time,
                    style:
                        AppTextStyles.tiny.copyWith(color: palette.textHint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
