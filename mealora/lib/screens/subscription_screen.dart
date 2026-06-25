import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

class _PlanInfo {
  final String title;
  final String price;
  final String subtitle;
  const _PlanInfo(this.title, this.price, this.subtitle);
}

/// Giới thiệu các gói đăng ký giao hàng hiện có (giống lựa chọn ở Giỏ hàng).
/// Hiện app chưa lưu trạng thái "đang đăng ký gói nào" - màn này mang tính
/// thông tin, việc chọn gói thực tế diễn ra khi đặt hàng ở Giỏ hàng.
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  static const List<_PlanInfo> _plans = [
    _PlanInfo('Giao 1 lần', 'Phí ship 15.000đ', 'Đặt theo từng đơn, không ràng buộc.'),
    _PlanInfo('Gói tuần (5 ngày)', 'Giảm 10% · Miễn phí ship',
        'Phù hợp nếu bạn ăn theo thực đơn hàng tuần.'),
    _PlanInfo('Gói tháng (20 ngày)', 'Giảm 20% · Miễn phí ship',
        'Tiết kiệm nhất cho khách hàng thân thiết.'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Gói đăng ký của tôi'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: palette.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: palette.textSecondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Bạn chưa đăng ký gói nào. Chọn gói giao hàng khi '
                          'thanh toán ở Giỏ hàng để được áp dụng ưu đãi.',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: palette.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Các gói hiện có',
                    style: AppTextStyles.subtitle
                        .copyWith(color: palette.textPrimary)),
                const SizedBox(height: 12),
                ..._plans.map((plan) => _buildPlanCard(context, plan)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, _PlanInfo plan) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.title,
                  style: AppTextStyles.semibold15
                      .copyWith(color: palette.textPrimary)),
              Text(plan.price,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: palette.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Text(plan.subtitle,
              style: AppTextStyles.caption.copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }
}
