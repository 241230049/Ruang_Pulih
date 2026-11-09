enum ConsultationStatus {
  menunggu,
  disetujui,
  selesai,
  dibatalkan,
}

extension ConsultationStatusExtension on ConsultationStatus {
  String get label {
    switch (this) {
      case ConsultationStatus.menunggu:
        return 'Menunggu Konfirmasi';
      case ConsultationStatus.disetujui:
        return 'Terkonfirmasi';
      case ConsultationStatus.selesai:
        return 'Selesai';
      case ConsultationStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final bool isFromUser;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isFromUser,
    required this.text,
    required this.timestamp,
  });
}

class ConsultationSession {
  final String id;
  final String korbanId;
  final String korbanName;
  final String volunteerId;
  final String volunteerName;
  final DateTime scheduledDate;
  final String timeSlot;
  final String consultationType; // 'Chat Anonim' / 'Voice Call'
  final ConsultationStatus status;
  final String notes;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  const ConsultationSession({
    required this.id,
    required this.korbanId,
    required this.korbanName,
    required this.volunteerId,
    required this.volunteerName,
    required this.scheduledDate,
    required this.timeSlot,
    this.consultationType = 'Chat Anonim',
    this.status = ConsultationStatus.disetujui,
    required this.notes,
    this.messages = const [],
    required this.createdAt,
  });

  ConsultationSession copyWith({
    String? id,
    String? korbanId,
    String? korbanName,
    String? volunteerId,
    String? volunteerName,
    DateTime? scheduledDate,
    String? timeSlot,
    String? consultationType,
    ConsultationStatus? status,
    String? notes,
    List<ChatMessage>? messages,
    DateTime? createdAt,
  }) {
    return ConsultationSession(
      id: id ?? this.id,
      korbanId: korbanId ?? this.korbanId,
      korbanName: korbanName ?? this.korbanName,
      volunteerId: volunteerId ?? this.volunteerId,
      volunteerName: volunteerName ?? this.volunteerName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      consultationType: consultationType ?? this.consultationType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

