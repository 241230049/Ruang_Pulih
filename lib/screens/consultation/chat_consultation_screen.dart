import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/consultation_model.dart';
import '../../services/app_state_service.dart';

class ChatConsultationScreen extends StatefulWidget {
  final String sessionId;
  final AppStateService appState;

  const ChatConsultationScreen({
    super.key,
    required this.sessionId,
    required this.appState,
  });

  @override
  State<ChatConsultationScreen> createState() => _ChatConsultationScreenState();
}

class _ChatConsultationScreenState extends State<ChatConsultationScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final session = widget.appState.consultations.firstWhere(
          (s) => s.id == widget.sessionId,
          orElse: () => ConsultationSession(
            id: '',
            korbanId: '',
            korbanName: '',
            volunteerId: '',
            volunteerName: '',
            scheduledDate: DateTime.fromMillisecondsSinceEpoch(0),
            timeSlot: '',
            notes: '',
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );

        if (session.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Konsultasi')),
            body: const Center(child: Text('Sesi tidak ditemukan')),
          );
        }

        _scrollToBottom();

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  radius: 18,
                  child: const Text('👩‍⚕️', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.volunteerName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${session.consultationType} • Online',
                        style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Safe Space Notice Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.surfaceVariant,
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Enkripsi Privasi: Identitas Anda dirahasiakan sepenuhnya.',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: session.messages.length,
                  itemBuilder: (context, index) {
                    final msg = session.messages[index];
                    final isMe = msg.isFromUser;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: isMe ? null : Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: isMe ? Colors.white : AppColors.textPrimary,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.timeAgo(msg.timestamp),
                              style: TextStyle(
                                fontSize: 9.5,
                                color: isMe ? Colors.white70 : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Message Input Bar
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan konseling...',
                          hintStyle: const TextStyle(fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          fillColor: AppColors.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                      onPressed: () {
                        final text = _msgController.text.trim();
                        if (text.isNotEmpty) {
                          widget.appState.sendConsultationMessage(session.id, text);
                          _msgController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
