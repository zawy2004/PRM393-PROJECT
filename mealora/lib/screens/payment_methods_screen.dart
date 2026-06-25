import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../models/payment_method.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

/// Quản lý phương thức thanh toán: xem danh sách, thêm, xóa.
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> _methods = [];
  bool _loading = true;

  String get _userId => SessionController.instance.userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await DatabaseService.instance.getPaymentMethods(_userId);
    if (!mounted) return;
    setState(() {
      _methods = list;
      _loading = false;
    });
  }

  Future<void> _openForm() async {
    final labelCtrl = TextEditingController();
    final detailCtrl = TextEditingController();

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thêm phương thức thanh toán', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(
                  labelText: 'Tên (VD: Tiền mặt, Ví MoMo, Thẻ tín dụng)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: detailCtrl,
              decoration: const InputDecoration(
                  labelText: 'Chi tiết (VD: **** 1234) - không bắt buộc'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (labelCtrl.text.trim().isEmpty) return;
                  Navigator.of(sheetContext).pop(true);
                },
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;

    final label = labelCtrl.text.trim();
    final method = PaymentMethod(
      userId: _userId,
      icon: PaymentMethod.iconForLabel(label),
      label: label,
      detail: detailCtrl.text.trim(),
    );
    await DatabaseService.instance.savePaymentMethod(method);
    await _load();
  }

  Future<void> _delete(PaymentMethod method) async {
    if (method.id == null) return;
    await DatabaseService.instance.deletePaymentMethod(method.id!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        backgroundColor: palette.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const AppHeader(title: 'Phương thức thanh toán'),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _methods.isEmpty
                    ? _buildEmpty(context)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _methods.length,
                        itemBuilder: (context, i) =>
                            _buildCard(context, _methods[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payment_outlined, size: 56, color: palette.textHint),
          const SizedBox(height: 12),
          Text('Chưa có phương thức thanh toán',
              style: AppTextStyles.body.copyWith(color: palette.textSecondary)),
          const SizedBox(height: 4),
          Text('Bấm + để thêm phương thức mới',
              style: AppTextStyles.caption.copyWith(color: palette.textHint)),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, PaymentMethod method) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(method.icon, color: palette.primary),
          const SizedBox(width: 12),
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
          IconButton(
            icon: Icon(Icons.delete_outline, color: palette.textHint),
            onPressed: () => _delete(method),
          ),
        ],
      ),
    );
  }
}
