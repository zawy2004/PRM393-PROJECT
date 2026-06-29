import 'package:flutter/material.dart';
import 'package:momo_payment_flutter/momo_payment_flutter.dart';
import '../data/sample_data.dart';
import '../database/database_service.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/payment_method.dart';
import '../models/transaction.dart';
import '../services/momo_service.dart';
import '../state/cart_controller.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import 'payment_result_screen.dart';

/// Màn hình thanh toán: địa chỉ giao, thời gian giao, phương thức thanh toán,
/// mã giảm giá và bảng tổng kết + nút đặt hàng.
class CheckoutScreen extends StatefulWidget {
  final int total;

  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with WidgetsBindingObserver {
  static const List<PaymentMethod> _methods = SampleData.paymentMethods;

  Address get _address => SampleData.addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => SampleData.addresses.first,
      );

  int _selectedMethod = 0;
  bool _loading = false;
  String _loadingLabel = 'Đang đặt hàng...';

  // Lưu lại orderId/requestId của giao dịch MoMo đang chờ xác nhận, để khi
  // app resume (người dùng quay lại từ app/trang MoMo) thì kiểm tra trạng thái.
  String? _pendingMomoOrderId;
  String? _pendingMomoRequestId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingMomoOrderId != null) {
      _checkMomoStatus();
    }
  }

  bool _isMomo(PaymentMethod method) =>
      method.label.toLowerCase().contains('momo');

  Future<void> _placeOrder() async {
    final method = _methods[_selectedMethod];
    if (_isMomo(method)) {
      await _payWithMomo();
    } else {
      await _finalizeOrder(method.label, paid: false);
    }
  }

  /// Tạo yêu cầu thanh toán MoMo (sandbox) và mở trang thanh toán.
  /// Kết quả sẽ được xác nhận ở [_checkMomoStatus] khi app resume.
  Future<void> _payWithMomo() async {
    setState(() {
      _loading = true;
      _loadingLabel = 'Đang khởi tạo thanh toán MoMo...';
    });

    final now = DateTime.now();
    final orderId = 'MM${now.millisecondsSinceEpoch}';
    final requestId = 'RQ${now.millisecondsSinceEpoch}';

    try {
      final info = MomoPaymentInfo(
        orderId: orderId,
        orderInfo: 'Thanh toan don hang Mealora',
        amount: widget.total,
        redirectUrl: MomoService.redirectUrl,
        ipnUrl: MomoService.ipnUrl,
        requestId: requestId,
        requestType: 'captureWallet',
        lang: 'vi',
      );

      final res = await MomoService.instance.momo.createPayment(info);
      if (res.payUrl == null) {
        _snack('Không tạo được thanh toán MoMo: ${res.message}');
        setState(() => _loading = false);
        return;
      }

      _pendingMomoOrderId = orderId;
      _pendingMomoRequestId = requestId;
      setState(() => _loadingLabel = 'Đang chờ xác nhận từ MoMo...');
      await MomoService.instance.momo.openPaymentPage(res.payUrl!);
      // Giữ trạng thái loading; sẽ được giải quyết ở didChangeAppLifecycleState
      // khi người dùng quay lại app sau khi thanh toán trên MoMo.
    } catch (e) {
      _pendingMomoOrderId = null;
      _pendingMomoRequestId = null;
      if (!mounted) return;
      setState(() => _loading = false);
      _snack('Lỗi thanh toán MoMo: $e');
    }
  }

  Future<void> _checkMomoStatus() async {
    final orderId = _pendingMomoOrderId!;
    final requestId = _pendingMomoRequestId!;
    _pendingMomoOrderId = null;
    _pendingMomoRequestId = null;

    if (!mounted) return;
    setState(() => _loadingLabel = 'Đang kiểm tra trạng thái thanh toán...');

    try {
      final res = await MomoService.instance.momo
          .checkStatus(orderId: orderId, requestId: requestId);

      if (res.resultCode == 0) {
        await _finalizeOrder('Ví MoMo', paid: true);
      } else {
        await DatabaseService.instance.recordTransaction(PaymentTransaction(
          userId: SessionController.instance.userId,
          method: 'Ví MoMo',
          amount: widget.total,
          status: 'failed',
          message: res.message,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
        if (!mounted) return;
        setState(() => _loading = false);
        _goToResult(
          success: false,
          paymentLabel: 'Ví MoMo',
          paid: false,
          errorMessage:
              'Thanh toán MoMo không thành công (${res.resultCode}): ${res.message}',
        );
      }
    } catch (e) {
      await DatabaseService.instance.recordTransaction(PaymentTransaction(
        userId: SessionController.instance.userId,
        method: 'Ví MoMo',
        amount: widget.total,
        status: 'failed',
        message: '$e',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
      if (!mounted) return;
      setState(() => _loading = false);
      _goToResult(
        success: false,
        paymentLabel: 'Ví MoMo',
        paid: false,
        errorMessage: 'Lỗi kiểm tra trạng thái MoMo: $e',
      );
    }
  }

  void _goToResult({
    required bool success,
    required String paymentLabel,
    required bool paid,
    String orderId = '',
    int? amount,
    String? errorMessage,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentResultScreen(
          success: success,
          orderId: orderId,
          amount: amount ?? widget.total,
          paymentLabel: paymentLabel,
          paid: paid,
          errorMessage: errorMessage,
        ),
      ),
    );
  }

  /// Lưu đơn hàng vào DB, đẩy thông báo, xóa giỏ hàng rồi chuyển sang trang
  /// kết quả thanh toán. Dùng chung cho cả thanh toán tiền mặt/thẻ (gọi trực
  /// tiếp, [paid] = false vì chưa có cổng xử lý thật) và MoMo (gọi sau khi
  /// [_checkMomoStatus] xác nhận thành công, [paid] = true).
  Future<void> _finalizeOrder(String paymentLabel, {required bool paid}) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _loadingLabel = 'Đang đặt hàng...';
    });

    final cart = CartController.instance;
    final userId = SessionController.instance.userId;
    final now = DateTime.now();
    final orderId = 'MP${now.millisecondsSinceEpoch}';

    final order = Order(
      id: '#$orderId',
      userId: userId,
      subtotal: cart.subtotal,
      discount: cart.subtotal - widget.total < 0 ? 0 : cart.subtotal - widget.total,
      shippingFee: widget.total > cart.subtotal ? widget.total - cart.subtotal : 0,
      total: widget.total,
      deliveryPlan: 'Giao hàng',
      addressDetail: _address.detail,
      paymentLabel: paymentLabel,
      status: 'delivering',
      paymentStatus: paid ? 'paid' : 'unpaid',
      createdAt: now.millisecondsSinceEpoch,
    );

    final items = cart.lines
        .map((l) => OrderItem(
              orderId: '#$orderId',
              mealId: l.item.id,
              mealName: l.item.name,
              price: l.item.price,
              quantity: l.quantity,
            ))
        .toList();

    await DatabaseService.instance.placeOrder(order, items);
    await DatabaseService.instance.recordTransaction(PaymentTransaction(
      userId: userId,
      orderId: order.id,
      method: paymentLabel,
      amount: widget.total,
      status: 'success',
      createdAt: now.millisecondsSinceEpoch,
    ));
    await DatabaseService.instance.pushNotification(
      userId: userId,
      title: 'Đơn hàng đang được giao',
      description: 'Shipper đang trên đường giao đơn #$orderId đến bạn.',
      iconLabel: 'delivery_dining',
    );

    cart.clear();

    if (!mounted) return;
    setState(() => _loading = false);
    _goToResult(
      success: true,
      orderId: order.id,
      amount: widget.total,
      paymentLabel: paymentLabel,
      paid: paid,
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
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
                label: _loading ? _loadingLabel : 'Đặt hàng',
                height: 48,
                onPressed: _loading ? null : _placeOrder),
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
