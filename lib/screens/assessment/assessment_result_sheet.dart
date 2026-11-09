import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/assessment_model.dart';

class AssessmentResultSheet extends StatelessWidget {
  final AssessmentResult result;
  final VoidCallback onConsultationPressed;
  final VoidCallback onJournalPressed;

  const AssessmentResultSheet({
    super.key,
    required this.result,
    required this.onConsultationPressed,
    required this.onJournalPressed,
  });

  static void show(
    BuildContext context, {
    required AssessmentResult result,
    required VoidCallback onConsultationPressed,
    required VoidCallback onJournalPressed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AssessmentResultSheet(
        result: result,
        onConsultationPressed: onConsultationPressed,
        onJournalPressed: onJournalPressed,
      ),
    );
  }

  Color _getLevelColor(AddictionLevel level) {
    switch (level) {
      case AddictionLevel.ringan:
        return AppColors.success;
      case AddictionLevel.sedang:
        return AppColors.warning;
      case AddictionLevel.berat:
        return AppColors.danger;
    }
  }

  Color _getLevelBgColor(AddictionLevel level) {
    switch (level) {
      case AddictionLevel.ringan:
        return const Color(0xFFD1FAE5);
      case AddictionLevel.sedang:
        return const Color(0xFFFEF3C7);
      case AddictionLevel.berat:
        return const Color(0xFFFFE4E6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = result.level;
    final levelColor = _getLevelColor(level);
    final levelBg = _getLevelBgColor(level);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: levelBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: levelColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.analytics_rounded, color: levelColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Skor SOGS: ${result.totalScore} / 10',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: levelColor,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                level.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: levelColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              level.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 20),
            const Text(
              'Langkah Aksi yang Direkomendasikan:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...level.recommendations.map((rec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFCCFBF1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 14, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.35),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConsultationPressed();
                    },
                    child: const Text('Konseling Sebaya'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onJournalPressed();
                    },
                    child: const Text('Isi Jurnal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
