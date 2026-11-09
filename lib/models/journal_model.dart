class JournalEntry {
  final String id;
  final String userId;
  final int mood; // 1 - 5
  final String note;
  final String trigger;
  final int dayStreak;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.userId,
    required this.mood,
    required this.note,
    this.trigger = 'Tidak ada pemicu',
    required this.dayStreak,
    required this.createdAt,
  });

  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😫';
      case 2:
        return '😔';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '💪';
      default:
        return '😐';
    }
  }

  String get moodLabel {
    switch (mood) {
      case 1:
        return 'Sangat Cemas';
      case 2:
        return 'Cemas / Tertekan';
      case 3:
        return 'Netral';
      case 4:
        return 'Tenang & Stabil';
      case 5:
        return 'Kuat & Optimis';
      default:
        return 'Netral';
    }
  }
}

