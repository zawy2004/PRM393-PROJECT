/// Địa chỉ giao hàng của người dùng.
class Address {
  final String label; // VD: "Nhà", "Công ty"
  final String detail; // Địa chỉ đầy đủ
  final bool isDefault;

  const Address({
    required this.label,
    required this.detail,
    this.isDefault = false,
  });
}
