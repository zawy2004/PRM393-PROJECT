class User {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String? phone;
  final int createdAt;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone': phone,
        'created_at': createdAt,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        fullName: map['full_name'] as String,
        phone: map['phone'] as String?,
        createdAt: map['created_at'] as int,
      );

  User copyWith({
    String? email,
    String? password,
    String? fullName,
    String? phone,
  }) =>
      User(
        id: id,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        createdAt: createdAt,
      );
}
