import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../models/transaction.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/app_header.dart';

/// Lịch sử giao dịch thanh toán của tài khoản đang đăng nhập - gồm cả các
/// lượt thành công, thất bại và bị hủy (khác Đơn hàng chỉ có lượt thành công).
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<PaymentTransaction> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userId = SessionController.instance.userId;
    final txs = await DatabaseService.instance.getTransactionHistory(userId);
    if (!mounted) return;
    setState(() {
      _transactions = txs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Lịch sử giao dịch'),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _transactions.isEmpty
                    ? _buildEmpty(palette)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _transactions.length,
                        itemBuilder: (context, i) =>
                            _buildCard(palette, _transactions[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppPalette palette) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: palette.textHint),
          const SizedBox(height: 16),
          Text('Chưa có giao dịch nào',
              style: AppTextStyles.subtitle.copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildCard(AppPalette palette, PaymentTransaction tx) {
    final dt = DateTime.fromMillisecondsSinceEpoch(tx.createdAt);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _statusColor(tx.status).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon(tx.status), color: _statusColor(tx.status), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.method,
                    style: AppTextStyles.semibold15.copyWith(color: palette.textPrimary)),
                const SizedBox(height: 4),
                Text('${Formatters.shortDate(dt)} · ${tx.orderId ?? 'Chưa tạo đơn'}',
                    style: AppTextStyles.caption.copyWith(color: palette.textSecondary)),
                if (tx.status != 'success' && tx.message != null) ...[
                  const SizedBox(height: 4),
                  Text(tx.message!,
                      style: AppTextStyles.caption.copyWith(color: palette.textHint),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.price(tx.amount),
                  style: AppTextStyles.semibold15.copyWith(color: palette.textPrimary)),
              const SizedBox(height: 4),
              Text(_statusLabel(tx.status),
                  style: AppTextStyles.caption
                      .copyWith(color: _statusColor(tx.status), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'success':
        return 'Thành công';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Thất bại';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'success':
        return const Color(0xFF22C55E);
      case 'cancelled':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'success':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.remove_circle_outline;
      default:
        return Icons.error_outline;
    }
  }
}
