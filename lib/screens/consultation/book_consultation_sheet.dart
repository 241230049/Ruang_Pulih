import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/volunteer_model.dart';
import '../../services/app_state_service.dart';

class BookConsultationSheet extends StatefulWidget {
  final VolunteerProfile volunteer;
  final AppStateService appState;

  const BookConsultationSheet({
    super.key,
    required this.volunteer,
    required this.appState,
  });

  static void show(BuildContext context, {
    required VolunteerProfile volunteer,
    required AppStateService appState,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BookConsultationSheet(volunteer: volunteer, appState: appState),
    );
  }

  @override
  State<BookConsultationSheet> createState() => _BookConsultationSheetState();
}

class _BookConsultationSheetState extends State<BookConsultationSheet> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '19:30 - 20:30 WIB';
  String _selectedType = 'Chat Anonim';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _timeSlots = const [
    '13:00 - 14:00 WIB',
    '15:30 - 16:30 WIB',
    '19:30 - 20:30 WIB',
    '20:45 - 21:45 WIB',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  radius: 22,
                  child: Text(widget.volunteer.avatarUrl, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.volunteer.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 16, color: AppColors.primary),
                        ],
                      ),
                      Text(
                        '${widget.volunteer.faculty} • ${widget.volunteer.university}',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Jadwalkan Konseling 1-on-1 Bebas Biaya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sesi berlangsung 60 menit. Seluruh percakapan dijamin kerahasiaannya.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Mode Konseling
            const Text(
              'Metode Konsultasi',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 16),
                        SizedBox(width: 6),
                        Text('Chat Anonim'),
                      ],
                    ),
                    selected: _selectedType == 'Chat Anonim',
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) {
                      if (val) setState(() => _selectedType = 'Chat Anonim');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_in_talk, size: 16),
                        SizedBox(width: 6),
                        Text('Voice Call'),
                      ],
                    ),
                    selected: _selectedType == 'Voice Call',
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) {
                      if (val) setState(() => _selectedType = 'Voice Call');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pilihan Jam
            const Text(
              'Pilih Sesi Waktu',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedSlot = slot);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Catatan Awal
            const Text(
              'Topik yang ingin didiskusikan (Opsional)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Misal: Sering panik saat ditagih pinjol, butuh cara atur pikiran...',
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final notes = _notesController.text.trim();
                  widget.appState.bookConsultation(
                    volunteer: widget.volunteer,
                    date: _selectedDate,
                    timeSlot: _selectedSlot,
                    notes: notes.isEmpty ? 'Konsultasi pendampingan umum' : notes,
                    type: _selectedType,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sesi konseling dengan ${widget.volunteer.name} berhasil dijadwalkan!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Konfirmasi Jadwal Konseling'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

