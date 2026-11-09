import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../services/app_state_service.dart';

class CreatePostSheet extends StatefulWidget {
  final AppStateService appState;

  const CreatePostSheet({super.key, required this.appState});

  static void show(BuildContext context, AppStateService appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreatePostSheet(appState: appState),
    );
  }

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'Dukungan Emosional';
  bool _isAnonymous = true;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = AppConstants.forumCategories.where((c) => c != 'Semua').toList();

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
              'Tulis Menfess / Curhat Anonim',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ceritakan apapun tanpa rasa malu. Komunitas ini siap mendukung kamu.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Toggle Anonimitas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_rounded, color: AppColors.primaryDark, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kirim Sebagai Anonim',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primaryDark),
                        ),
                        Text(
                          _isAnonymous ? 'Nama samaran: ${widget.appState.currentUser.aliasName}' : 'Nama asli Anda akan ditampilkan',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isAnonymous,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _isAnonymous = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kategori Dropdown
            const Text(
              'Pilih Kategori Topik',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
              items: availableCategories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13.5)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),

            // Judul Postingan
            const Text(
              'Judul Cerita',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Masuk hari ke-20 tanpa slot, gimana cara lewatin godaan...',
              ),
            ),
            const SizedBox(height: 16),

            // Isi Cerita
            const Text(
              'Isi Curhatan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tuliskan unek-unek atau pertanyaan kamu secara jujur...',
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final content = _contentController.text.trim();
                  if (title.isEmpty || content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Harap lengkapi judul dan isi cerita')),
                    );
                    return;
                  }

                  widget.appState.addPost(
                    title: title,
                    content: content,
                    category: _selectedCategory,
                    isAnonymous: _isAnonymous,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cerita kamu berhasil diposting secara anonim! 🚀'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Posting Menfess Anonim'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
