import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import 'order_tracking_screen.dart';

/// Màn hình thanh toán: địa chỉ giao, thời gian giao, phương thức thanh toán,
/// mã giảm giá và bảng tổng kết + nút đặt hàng.
class CheckoutScreen extends StatefulWidget {
  final int total;

  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const List<PaymentMethod> _methods = SampleData.paymentMethods;

  // Địa chỉ mặc định (ưu tiên isDefault).
  Address get _address => SampleData.addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => SampleData.addresses.first,
      );

  int _selectedMethod = 0;

  void _placeOrder() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Thanh toán'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                // Địa chỉ giao hàng (lấy từ dữ liệu mẫu).
                _buildInfoCard(
                  label: 'Địa chỉ giao hàng (${_address.label})',
                  value: _address.detail,
                  onEdit: () {},
                ),
                const SizedBox(height: 14),
                // Thời gian giao.
                _buildInfoCard(
                  label: 'Thời gian giao',
                  value: 'Hôm nay, 11:30 - 12:00',
                  onEdit: () {},
                ),
                const SizedBox(height: 20),
                Text('Phương thức thanh toán',
                    style: AppTextStyles.subtitle
                        .copyWith(color: palette.textPrimary)),
                const SizedBox(height: 12),
                ...List.generate(_methods.length, (i) => _buildPayMethod(i)),
                const SizedBox(height: 8),
                _buildPromo(),
              ],
            ),
          ),
          _buildSummary(),
        ],
      ),
    );
  }

  /// Thẻ thông tin (địa chỉ / thời gian) kèm nút "Sửa".
  Widget _buildInfoCard({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: palette.textSecondary)),
                const SizedBox(height: 6),
                Text(value,
                    style: AppTextStyles.semibold15
                        .copyWith(color: palette.textPrimary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Text('Sửa',
                style: AppTextStyles.bodySmall.copyWith(
                    color: palette.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPayMethod(int index) {
    final palette = context.palette;
    final method = _methods[index];
    final selected = index == _selectedMethod;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? palette.primary : palette.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? palette.primary : palette.textHint,
              size: 18,
            ),
            const SizedBox(width: 12),
            Icon(method.icon, size: 20, color: palette.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.label,
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: palette.textPrimary)),
                  if (method.detail.isNotEmpty)
                    Text(method.detail,
                        style: AppTextStyles.caption
                            .copyWith(color: palette.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ô nhập mã giảm giá + nút "Áp dụng".
  Widget _buildPromo() {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined,
              size: 20, color: palette.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Mã giảm giá',
                style:
                    AppTextStyles.body.copyWith(color: palette.textSecondary)),
          ),
          GestureDetector(
            onTap: () {},
            child: Text('Áp dụng',
                style: AppTextStyles.bodySmall.copyWith(
                    color: palette.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _row('Tổng món', Formatters.price(widget.total)),
            const SizedBox(height: 8),
            _row('Phí giao hàng', 'Miễn phí'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng thanh toán',
                    style: AppTextStyles.subtitle
                        .copyWith(color: palette.textPrimary)),
                Text(Formatters.price(widget.total),
                    style: AppTextStyles.priceLarge
                        .copyWith(color: palette.primary, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
                label: 'Đặt hàng', height: 48, onPressed: _placeOrder),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    final palette = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.body.copyWith(color: palette.textSecondary)),
        Text(value,
            style:
                AppTextStyles.labelMedium.copyWith(color: palette.textPrimary)),
      ],
    );
  }
}
