import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/app_state_service.dart';

class AddJournalSheet extends StatefulWidget {
  final AppStateService appState;

  const AddJournalSheet({super.key, required this.appState});

  static void show(BuildContext context, AppStateService appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddJournalSheet(appState: appState),
    );
  }

  @override
  State<AddJournalSheet> createState() => _AddJournalSheetState();
}

class _AddJournalSheetState extends State<AddJournalSheet> {
  int _selectedMood = 4;
  String _selectedTrigger = 'Tidak ada pemicu';
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moodOptions = const [
    {'mood': 1, 'emoji': '😫', 'label': 'Down'},
    {'mood': 2, 'emoji': '😔', 'label': 'Cemas'},
    {'mood': 3, 'emoji': '😐', 'label': 'Netral'},
    {'mood': 4, 'emoji': '🙂', 'label': 'Tenang'},
    {'mood': 5, 'emoji': '💪', 'label': 'Kuat'},
  ];

  final List<String> _triggerOptions = const [
    'Tidak ada pemicu',
    'Iklan Medsos / Pop-up',
    'Ajakan Tongkrongan',
    'Kekhawatiran Finansial',
    'Rasa Bosan / Gabut',
    'Stres Kuliah / Kerja',
  ];

  @override
  void dispose() {
    _noteController.dispose();
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
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jurnal Pemulihan Harian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cukup 30 detik untuk check-in & rayakan hari bersih kamu.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // Mood Selector
            const Text(
              'Gimana perasaan kamu hari ini?',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moodOptions.map((item) {
                final isSelected = _selectedMood == item['mood'];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMood = item['mood'] as int;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryContainer : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(item['emoji'] as String, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Trigger Selector
            const Text(
              'Ada hal yang memicu godaan hari ini?',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _triggerOptions.map((trig) {
                final isSelected = _selectedTrigger == trig;
                return ChoiceChip(
                  label: Text(trig),
                  selected: isSelected,
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedTrigger = trig;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Catatan
            const Text(
              'Catatan / Hal Positif Hari Ini',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Contoh: Berhasil tahan godaan waktu nongkrong bareng teman, tidur lebih tenang...',
              ),
            ),
            const SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final text = _noteController.text.trim();
                  widget.appState.addJournalEntry(
                    mood: _selectedMood,
                    note: text.isEmpty ? 'Berhasil menjaga komitmen hari bersih!' : text,
                    trigger: _selectedTrigger,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jurnal tercatat! Streak kamu bertambah +1 hari! 🔥'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('Simpan Jurnal & Tambah Streak'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
