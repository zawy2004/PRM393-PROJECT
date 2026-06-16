/// Model đơn hàng đầy đủ dùng cho DB (khác OrderHistoryItem dùng để hiển thị UI).
class Order {
  final String id;
  final String userId;
  final int subtotal;
  final int discount;
  final int shippingFee;
  final int total;
  final String deliveryPlan;
  final String addressDetail;
  final String paymentLabel;
  /// 'delivering' | 'completed' | 'cancelled'
  final String status;
  final int createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.subtotal,
    required this.discount,
    required this.shippingFee,
    required this.total,
    required this.deliveryPlan,
    required this.addressDetail,
    required this.paymentLabel,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'subtotal': subtotal,
        'discount': discount,
        'shipping_fee': shippingFee,
        'total': total,
        'delivery_plan': deliveryPlan,
        'address_detail': addressDetail,
        'payment_label': paymentLabel,
        'status': status,
        'created_at': createdAt,
      };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        subtotal: map['subtotal'] as int,
        discount: map['discount'] as int,
        shippingFee: map['shipping_fee'] as int,
        total: map['total'] as int,
        deliveryPlan: map['delivery_plan'] as String,
        addressDetail: map['address_detail'] as String,
        paymentLabel: map['payment_label'] as String,
        status: map['status'] as String,
        createdAt: map['created_at'] as int,
      );
}

/// Một dòng món ăn trong đơn hàng.
class OrderItem {
  final int? id;
  final String orderId;
  final String mealId;
  final String mealName;
  final int price;
  final int quantity;

  const OrderItem({
    this.id,
    required this.orderId,
    required this.mealId,
    required this.mealName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'order_id': orderId,
        'meal_id': mealId,
        'meal_name': mealName,
        'price': price,
        'quantity': quantity,
      };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        id: map['id'] as int?,
        orderId: map['order_id'] as String,
        mealId: map['meal_id'] as String,
        mealName: map['meal_name'] as String,
        price: map['price'] as int,
        quantity: map['quantity'] as int,
      );
}
