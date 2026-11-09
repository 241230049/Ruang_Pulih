class RecoveryBadge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int requiredStreakDays;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const RecoveryBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requiredStreakDays,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  RecoveryBadge copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? requiredStreakDays,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return RecoveryBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      requiredStreakDays: requiredStreakDays ?? this.requiredStreakDays,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

