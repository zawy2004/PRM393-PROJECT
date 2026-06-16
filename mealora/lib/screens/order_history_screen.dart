import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../database/database_service.dart';
import '../models/order.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const List<String> _tabs = ['Tất cả', 'Đang giao', 'Hoàn thành', 'Đã hủy'];

  int _selectedTab = 0;
  List<OrderHistoryItem> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    final userId = SessionController.instance.userId;
    final dbOrders = await DatabaseService.instance.getOrderHistory(userId);

    if (dbOrders.isEmpty) {
      // Dùng dữ liệu mẫu khi chưa có đơn thật trong DB.
      setState(() {
        _orders = List.of(SampleData.orders);
        _loading = false;
      });
      return;
    }

    // Chuyển đổi Order (DB) → OrderHistoryItem (UI).
    final items = await Future.wait(dbOrders.map(_toHistoryItem));
    setState(() {
      _orders = items;
      _loading = false;
    });
  }

  Future<OrderHistoryItem> _toHistoryItem(Order order) async {
    final orderItems = await DatabaseService.instance.getOrderItems(order.id);
    final dt = DateTime.fromMillisecondsSinceEpoch(order.createdAt);
    final dateStr =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final itemNames =
        orderItems.isEmpty ? '—' : orderItems.map((i) => i.mealName).join(', ');

    OrderStatus status;
    switch (order.status) {
      case 'completed':
        status = OrderStatus.completed;
        break;
      case 'cancelled':
        status = OrderStatus.cancelled;
        break;
      default:
        status = OrderStatus.delivering;
    }

    return OrderHistoryItem(
      id: order.id,
      date: dateStr,
      items: itemNames,
      total: order.total,
      status: status,
    );
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTabs(),
                Expanded(
                  child: _visible.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          itemCount: _visible.length,
                          itemBuilder: (context, i) =>
                              _buildOrderCard(_visible[i]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmpty() {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: palette.textHint),
          const SizedBox(height: 16),
          Text('Chưa có đơn hàng nào',
              style: AppTextStyles.subtitle
                  .copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final palette = context.palette;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
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
              style: AppTextStyles.caption.copyWith(color: palette.textSecondary)),
          const SizedBox(height: 6),
          Text(order.items,
              style: AppTextStyles.bodySmall.copyWith(color: palette.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.price(order.total),
                  style:
                      AppTextStyles.subtitle.copyWith(color: palette.textPrimary)),
              _buildAction(order),
            ],
          ),
        ],
      ),
    );
  }

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
        color = const Color(0xFF3B82F6);
        break;
      case OrderStatus.cancelled:
        text = 'Đã hủy';
        color = const Color(0xFFEF4444);
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

  Widget _buildAction(OrderHistoryItem order) {
    final palette = context.palette;
    if (order.status == OrderStatus.cancelled) return const SizedBox.shrink();
    final isDelivering = order.status == OrderStatus.delivering;
    return GestureDetector(
      onTap: () {
        if (isDelivering) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OrderTrackingScreen()));
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
