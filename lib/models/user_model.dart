enum UserRole {
  korban,
  volunteer,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.korban:
        return 'Pejuang Pulih';
      case UserRole.volunteer:
        return 'Volunteer Konselor';
      case UserRole.admin:
        return 'Admin RuangPulih';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isAnonymous;
  final String aliasName;
  final String avatar;
  final int currentStreak;
  final double savedMoney;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isAnonymous = true,
    required this.aliasName,
    this.avatar = '🌱',
    this.currentStreak = 14,
    this.savedMoney = 2400000,
    required this.createdAt,
  });

  String get publicDisplayName => isAnonymous ? aliasName : name;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    bool? isAnonymous,
    String? aliasName,
    String? avatar,
    int? currentStreak,
    double? savedMoney,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      aliasName: aliasName ?? this.aliasName,
      avatar: avatar ?? this.avatar,
      currentStreak: currentStreak ?? this.currentStreak,
      savedMoney: savedMoney ?? this.savedMoney,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

