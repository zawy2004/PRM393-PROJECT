import 'package:flutter/material.dart';

/// Phương thức thanh toán hiển thị ở màn Checkout & Profile.
class PaymentMethod {
  final IconData icon;
  final String label;
  final String detail;

  const PaymentMethod({
    required this.icon,
    required this.label,
    this.detail = '',
  });
}
