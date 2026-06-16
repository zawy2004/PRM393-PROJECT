import 'package:flutter/material.dart';

/// Phương thức thanh toán hiển thị ở màn Checkout & Profile.
class PaymentMethod {
  final int? id;
  final String? userId;
  final IconData icon;
  final String label;
  final String detail;

  const PaymentMethod({
    this.id,
    this.userId,
    required this.icon,
    required this.label,
    this.detail = '',
  });

  /// Icon được suy ra từ label khi load từ DB (tránh lưu codePoint động).
  static IconData iconForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('momo') || l.contains('ví')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (l.contains('tín dụng') || l.contains('thẻ') || l.contains('visa')) {
      return Icons.credit_card;
    }
    return Icons.money;
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'label': label,
        'detail': detail,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    final label = map['label'] as String;
    return PaymentMethod(
      id: map['id'] as int?,
      userId: map['user_id'] as String?,
      icon: iconForLabel(label),
      label: label,
      detail: map['detail'] as String? ?? '',
    );
  }
}
