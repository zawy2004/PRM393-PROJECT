/// Một lượt giao dịch thanh toán (lưu cả các lần thất bại/hủy, khác với
/// [Order] chỉ tồn tại khi đặt hàng thành công).
class PaymentTransaction {
  final int? id;
  final String userId;
  final String? orderId;
  final String method;
  final int amount;
  /// 'success' | 'failed' | 'cancelled'
  final String status;
  final String? message;
  final int createdAt;

  const PaymentTransaction({
    this.id,
    required this.userId,
    this.orderId,
    required this.method,
    required this.amount,
    required this.status,
    this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'order_id': orderId,
        'method': method,
        'amount': amount,
        'status': status,
        'message': message,
        'created_at': createdAt,
      };

  factory PaymentTransaction.fromMap(Map<String, dynamic> map) =>
      PaymentTransaction(
        id: map['id'] as int?,
        userId: map['user_id'] as String,
        orderId: map['order_id'] as String?,
        method: map['method'] as String,
        amount: map['amount'] as int,
        status: map['status'] as String,
        message: map['message'] as String?,
        createdAt: map['created_at'] as int,
      );
}
