import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../state/cart_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/food_image.dart';
import '../widgets/primary_button.dart';
import 'checkout_screen.dart';

/// Một gói giao hàng.
class _DeliveryPlan {
  final String title;
  final String subtitle;
  final double discount; // 0.0 - 1.0
  final bool freeShip;
  final bool highlightSubtitle;

  const _DeliveryPlan({
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.freeShip,
    this.highlightSubtitle = false,
  });
}

/// Màn hình giỏ hàng: danh sách món + chỉnh số lượng, chọn gói giao,
/// và bảng tổng kết chi phí + nút thanh toán.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const int _shipFee = 15000;

  final _cart = CartController.instance;
  List<CartLine> get _lines => _cart.lines;

  static const List<_DeliveryPlan> _plans = [
    _DeliveryPlan(
        title: 'Giao 1 lần',
        subtitle: 'Phí ship: 15.000đ',
        discount: 0,
        freeShip: false),
    _DeliveryPlan(
        title: 'Gói tuần (5 ngày)',
        subtitle: 'Miễn phí ship · Giảm 10%',
        discount: 0.10,
        freeShip: true,
        highlightSubtitle: true),
    _DeliveryPlan(
        title: 'Gói tháng (20 ngày)',
        subtitle: 'Miễn phí ship · Giảm 20%',
        discount: 0.20,
        freeShip: true),
  ];

  int _selectedPlan = 1;

  // ---- Các giá trị tính toán ----
  int get _subtotal => _cart.subtotal;
  _DeliveryPlan get _plan => _plans[_selectedPlan];
  int get _discount => (_subtotal * _plan.discount).round();
  int get _ship => _plan.freeShip ? 0 : _shipFee;
  int get _total => _subtotal - _discount + _ship;

  void _changeQty(CartLine line, int delta) =>
      _cart.changeQuantity(line, delta);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.surface,
        surfaceTintColor: palette.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Giỏ hàng',
            style:
                AppTextStyles.appBarTitle.copyWith(color: palette.textPrimary)),
      ),
      // Lắng nghe CartController để tự cập nhật khi đổi số lượng.
      body: ListenableBuilder(
        listenable: _cart,
        builder: (context, _) {
          if (_lines.isEmpty) return _buildEmpty();
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    ..._lines.map(_buildCartItem),
                    const SizedBox(height: 12),
                    Text('Chọn gói giao',
                        style: AppTextStyles.subtitle
                            .copyWith(color: palette.textPrimary)),
                    const SizedBox(height: 12),
                    ...List.generate(_plans.length, (i) => _buildPlan(i)),
                  ],
                ),
              ),
              _buildSummary(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: palette.textHint),
          const SizedBox(height: 16),
          Text('Giỏ hàng trống',
              style: AppTextStyles.subtitle
                  .copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }

  /// Một dòng món trong giỏ: ảnh + tên + giá + bộ chỉnh số lượng.
  Widget _buildCartItem(CartLine line) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 64,
              height: 64,
              child: FoodImage(imageUrl: line.item.imageUrl),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.item.name,
                    style: AppTextStyles.semibold15
                        .copyWith(color: palette.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(Formatters.price(line.item.price),
                    style: AppTextStyles.semibold14
                        .copyWith(color: palette.primary)),
              ],
            ),
          ),
          _QtyStepper(
            quantity: line.quantity,
            onMinus: () => _changeQty(line, -1),
            onPlus: () => _changeQty(line, 1),
          ),
        ],
      ),
    );
  }

  /// Một lựa chọn gói giao có radio.
  Widget _buildPlan(int index) {
    final palette = context.palette;
    final plan = _plans[index];
    final selected = index == _selectedPlan;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
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
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.title,
                      style: AppTextStyles.semibold15
                          .copyWith(color: palette.textPrimary)),
                  const SizedBox(height: 2),
                  Text(plan.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: plan.highlightSubtitle
                            ? palette.primary
                            : palette.textSecondary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bảng tổng kết chi phí cố định dưới cùng.
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
            _summaryRow('Tạm tính', Formatters.price(_subtotal)),
            const SizedBox(height: 8),
            _summaryRow(
              'Giảm giá (${(_plan.discount * 100).round()}%)',
              '-${Formatters.price(_discount)}',
              valueColor: palette.primary,
            ),
            const SizedBox(height: 8),
            _summaryRow('Phí giao hàng',
                _ship == 0 ? 'Miễn phí' : Formatters.price(_ship)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _summaryRow(
              'Tổng cộng',
              Formatters.price(_total),
              isTotal: true,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Thanh toán',
              height: 48,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(total: _total),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    final palette = context.palette;
    final labelStyle = isTotal
        ? AppTextStyles.subtitle.copyWith(color: palette.textPrimary)
        : AppTextStyles.body.copyWith(color: palette.textSecondary);
    final valueStyle = isTotal
        ? AppTextStyles.priceLarge
            .copyWith(color: palette.primary, fontSize: 20)
        : AppTextStyles.labelMedium
            .copyWith(color: valueColor ?? palette.textPrimary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

/// Bộ tăng/giảm số lượng (−  n  +).
class _QtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtyStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        _squareButton(
          icon: Icons.remove,
          background: palette.surfaceVariant,
          iconColor: palette.textSecondary,
          onTap: onMinus,
        ),
        SizedBox(
          width: 28,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: AppTextStyles.semibold15.copyWith(color: palette.textPrimary),
          ),
        ),
        _squareButton(
          icon: Icons.add,
          background: palette.primary,
          iconColor: Colors.white,
          onTap: onPlus,
        ),
      ],
    );
  }

  Widget _squareButton({
    required IconData icon,
    required Color background,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
