import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

/// Một bước trong tiến trình giao hàng.
class _TrackStep {
  final String label;
  final String? time;
  const _TrackStep(this.label, [this.time]);
}

/// Màn hình theo dõi đơn hàng: mã đơn, bản đồ (placeholder), tiến trình
/// các bước giao hàng và thanh liên hệ shipper.
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  static const List<_TrackStep> _steps = [
    _TrackStep('Đã xác nhận', '11:02'),
    _TrackStep('Đang chuẩn bị', '11:10'),
    _TrackStep('Đang giao hàng', '11:25'),
    _TrackStep('Sắp đến nơi'),
    _TrackStep('Đã giao'),
  ];

  // Bước hiện tại (các bước <= chỉ số này coi như đã hoàn thành/đang chạy).
  static const int _currentStep = 2;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Theo dõi đơn'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                _buildOrderCard(context),
                const SizedBox(height: 16),
                _buildMap(context),
                const SizedBox(height: 16),
                _buildSteps(context),
              ],
            ),
          ),
          _buildContactBar(context),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đơn hàng #MP2026061201',
              style: AppTextStyles.semibold15
                  .copyWith(color: palette.textPrimary)),
          const SizedBox(height: 4),
          Text('Đang giao hàng',
              style:
                  AppTextStyles.bodySmall.copyWith(color: palette.primary)),
        ],
      ),
    );
  }

  /// Vùng bản đồ - placeholder (thay bằng Google Maps sau).
  Widget _buildMap(BuildContext context) {
    final palette = context.palette;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: palette.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 40, color: palette.textHint),
          const SizedBox(height: 8),
          Text('Bản đồ theo dõi',
              style: AppTextStyles.body.copyWith(color: palette.textHint)),
        ],
      ),
    );
  }

  /// Danh sách các bước giao hàng dạng timeline dọc.
  Widget _buildSteps(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: List.generate(_steps.length, (index) {
          final step = _steps[index];
          final done = index <= _currentStep;
          final isLast = index == _steps.length - 1;
          return _buildStepRow(context, step, done, isLast);
        }),
      ),
    );
  }

  Widget _buildStepRow(
      BuildContext context, _TrackStep step, bool done, bool isLast) {
    final palette = context.palette;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột chấm tròn + đường nối.
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: done ? palette.primary : palette.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done ? palette.primary : palette.border,
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? palette.primary : palette.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Nhãn + thời gian.
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step.label,
                    style: AppTextStyles.semibold14.copyWith(
                      color: done ? palette.textPrimary : palette.textHint,
                    ),
                  ),
                  if (step.time != null)
                    Text(step.time!,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: palette.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Thanh liên hệ shipper với nút gọi.
  Widget _buildContactBar(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: palette.surfaceVariant,
              child: Icon(Icons.delivery_dining, color: palette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Anh Minh',
                      style: AppTextStyles.semibold14
                          .copyWith(color: palette.textPrimary)),
                  Text('Shipper · 5 sao',
                      style: AppTextStyles.caption
                          .copyWith(color: palette.textSecondary)),
                ],
              ),
            ),
            // Nút gọi.
            Container(
              width: 48,
              height: 40,
              decoration: BoxDecoration(
                color: palette.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
