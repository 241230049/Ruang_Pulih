import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/app_state_service.dart';
import 'article_detail_screen.dart';
import 'loss_calculator_screen.dart';
import '../dashboard/emergency_sheet.dart';

class EducationTab extends StatelessWidget {
  final AppStateService appState;

  const EducationTab({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final articles = appState.educationalContents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi, Literasi & Hotline'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Unggulan: Kalkulator Kerugian
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LossCalculatorScreen(appState: appState),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.danger.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🧮', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kalkulator Simulasi Kerugian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Hitung berapa uang yang hilang dalam 1-5 tahun dan apa yang bisa Anda selamatkan!',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Panic / Emergency Hotline Quick Access
          InkWell(
            onTap: () => EmergencySheet.show(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone_in_talk, color: AppColors.primary, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Butuh Bantuan Krisis Cepat?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          'Hotline gratis Kemenkes 119, Satgas PASTI OJK 157',
                          style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Daftar Artikel Edukasi
          const Text(
            'Artikel & Panduan Pemulihan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),

          ...articles.map((art) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(article: art),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              art.category,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          Text(
                            art.readTime,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        art.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        art.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Penulis: ${art.author}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const Spacer(),
                          const Text(
                            'Baca Selengkapnya',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

