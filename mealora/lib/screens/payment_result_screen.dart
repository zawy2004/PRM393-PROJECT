import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/primary_button.dart';
import 'order_tracking_screen.dart';

/// Trang kết quả thanh toán: thành công (kèm thông tin đơn + nút theo dõi)
/// hoặc thất bại/đã hủy (kèm lý do + nút thử lại).
class PaymentResultScreen extends StatelessWidget {
  final bool success;
  final String orderId;
  final int amount;
  final String paymentLabel;
  /// Đã thanh toán (MoMo xác nhận) hay chưa (tiền mặt/thẻ - thu khi giao).
  final bool paid;
  final String? errorMessage;

  const PaymentResultScreen({
    super.key,
    required this.success,
    required this.orderId,
    required this.amount,
    required this.paymentLabel,
    required this.paid,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.cancel,
                size: 84,
                color: success ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
              ),
              const SizedBox(height: 20),
              Text(
                success ? 'Thanh toán thành công' : 'Thanh toán không thành công',
                style: AppTextStyles.titleLarge.copyWith(color: palette.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                success
                    ? 'Đơn hàng $orderId của bạn đã được ghi nhận.'
                    : (errorMessage ?? 'Giao dịch đã bị hủy hoặc gặp lỗi.'),
                style: AppTextStyles.body.copyWith(color: palette.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              if (success) _buildSummaryCard(palette),
              const SizedBox(height: 32),
              if (success) ...[
                PrimaryButton(
                  label: 'Theo dõi đơn hàng',
                  icon: Icons.delivery_dining,
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                    (route) => route.isFirst,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Về trang chủ'),
                ),
              ] else ...[
                PrimaryButton(
                  label: 'Thử lại',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Về trang chủ'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(AppPalette palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _row(palette, 'Mã đơn hàng', orderId),
          const SizedBox(height: 10),
          _row(palette, 'Số tiền', Formatters.price(amount)),
          const SizedBox(height: 10),
          _row(palette, 'Phương thức', paymentLabel),
          const SizedBox(height: 10),
          _row(palette, 'Trạng thái', paid ? 'Đã thanh toán' : 'Chưa thanh toán (thu khi giao)',
              valueColor: paid ? const Color(0xFF22C55E) : const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _row(AppPalette palette, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: palette.textSecondary)),
        Text(value,
            style: AppTextStyles.labelMedium
                .copyWith(color: valueColor ?? palette.textPrimary)),
      ],
    );
  }
}
