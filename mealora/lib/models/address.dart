/// Địa chỉ giao hàng của người dùng.
class Address {
  final int? id;
  final String? userId;
  final String label; // VD: "Nhà", "Công ty"
  final String detail; // Địa chỉ đầy đủ
  final bool isDefault;

  const Address({
    this.id,
    this.userId,
    required this.label,
    required this.detail,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'label': label,
        'detail': detail,
        'is_default': isDefault ? 1 : 0,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };

  factory Address.fromMap(Map<String, dynamic> map) => Address(
        id: map['id'] as int?,
        userId: map['user_id'] as String?,
        label: map['label'] as String,
        detail: map['detail'] as String,
        isDefault: (map['is_default'] as int?) == 1,
      );

  Address copyWith({String? label, String? detail, bool? isDefault}) => Address(
        id: id,
        userId: userId,
        label: label ?? this.label,
        detail: detail ?? this.detail,
        isDefault: isDefault ?? this.isDefault,
      );
}
