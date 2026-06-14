import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'order_tracking_screen.dart';

/// Màn hình lịch sử đơn hàng: thanh tab lọc trạng thái + danh sách đơn.
/// Đây là một tab trong MainShell nên không có nút back.
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const List<String> _tabs = ['Tất cả', 'Đang giao', 'Hoàn thành', 'Đã hủy'];

  static const List<OrderHistoryItem> _orders = SampleData.orders;

  int _selectedTab = 0;

  List<OrderHistoryItem> get _visible {
    switch (_selectedTab) {
      case 1:
        return _orders.where((o) => o.status == OrderStatus.delivering).toList();
      case 2:
        return _orders.where((o) => o.status == OrderStatus.completed).toList();
      case 3:
        return _orders.where((o) => o.status == OrderStatus.cancelled).toList();
      default:
        return _orders;
    }
  }

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
        title: Text('Đơn hàng',
            style:
                AppTextStyles.appBarTitle.copyWith(color: palette.textPrimary)),
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _visible.length,
              itemBuilder: (context, index) => _buildOrderCard(_visible[index]),
            ),
          ),
        ],
      ),
    );
  }

  /// Thanh tab cuộn ngang lọc theo trạng thái.
  Widget _buildTabs() {
    final palette = context.palette;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? palette.primary : palette.surface,
                borderRadius: BorderRadius.circular(16),
                border: selected ? null : Border.all(color: palette.border),
              ),
              child: Text(
                _tabs[index],
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : palette.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Một thẻ đơn hàng với badge trạng thái và nút "Đặt lại".
  Widget _buildOrderCard(OrderHistoryItem order) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.id,
                  style: AppTextStyles.semibold15
                      .copyWith(color: palette.textPrimary)),
              _buildBadge(order.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(order.date,
              style:
                  AppTextStyles.caption.copyWith(color: palette.textSecondary)),
          const SizedBox(height: 6),
          Text(order.items,
              style:
                  AppTextStyles.bodySmall.copyWith(color: palette.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.price(order.total),
                  style: AppTextStyles.subtitle
                      .copyWith(color: palette.textPrimary)),
              _buildAction(order),
            ],
          ),
        ],
      ),
    );
  }

  /// Badge màu theo trạng thái đơn.
  Widget _buildBadge(OrderStatus status) {
    final palette = context.palette;
    late final String text;
    late final Color color;
    switch (status) {
      case OrderStatus.delivering:
        text = 'Đang giao';
        color = palette.primary;
        break;
      case OrderStatus.completed:
        text = 'Hoàn thành';
        color = const Color(0xFF3B82F6); // xanh dương
        break;
      case OrderStatus.cancelled:
        text = 'Đã hủy';
        color = const Color(0xFFEF4444); // đỏ
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: AppTextStyles.caption
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }

  /// Nút hành động: "Theo dõi" khi đang giao, "Đặt lại" khi đã xong.
  Widget _buildAction(OrderHistoryItem order) {
    final palette = context.palette;
    if (order.status == OrderStatus.cancelled) return const SizedBox.shrink();

    final isDelivering = order.status == OrderStatus.delivering;
    return GestureDetector(
      onTap: () {
        if (isDelivering) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const OrderTrackingScreen()));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: palette.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(isDelivering ? 'Theo dõi' : 'Đặt lại',
            style: AppTextStyles.caption
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
