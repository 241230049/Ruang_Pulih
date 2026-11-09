import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/app_state_service.dart';
import 'assessment_result_sheet.dart';

class AssessmentScreen extends StatefulWidget {
  final AppStateService appState;
  final VoidCallback onNavigateToConsultation;
  final VoidCallback onNavigateToJournal;

  const AssessmentScreen({
    super.key,
    required this.appState,
    required this.onNavigateToConsultation,
    required this.onNavigateToJournal,
  });

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionId -> score

  @override
  Widget build(BuildContext context) {
    final questions = widget.appState.sogsQuestions;
    final currentQ = questions[_currentIndex];
    final progress = (_currentIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asesmen Kecanduan (SOGS)'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pertanyaan ${_currentIndex + 1} dari ${questions.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentQ.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Question Text
              Text(
                currentQ.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: currentQ.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, optIdx) {
                    final opt = currentQ.options[optIdx];
                    final isSelected = _selectedAnswers[currentQ.id] == opt.score;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAnswers[currentQ.id] = opt.score;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                opt.text,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation Buttons
              Row(
                children: [
                  if (_currentIndex > 0)
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex--;
                        });
                      },
                      child: const Text('Kembali'),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedAnswers.containsKey(currentQ.id)
                          ? () {
                              if (_currentIndex < questions.length - 1) {
                                setState(() {
                                  _currentIndex++;
                                });
                              } else {
                                // Selesai kuesioner, simpan hasil
                                widget.appState.saveAssessmentResult(_selectedAnswers);
                                final result = widget.appState.lastAssessmentResult;
                                if (result != null) {
                                  AssessmentResultSheet.show(
                                    context,
                                    result: result,
                                    onConsultationPressed: () {
                                      Navigator.pop(context);
                                      widget.onNavigateToConsultation();
                                    },
                                    onJournalPressed: () {
                                      Navigator.pop(context);
                                      widget.onNavigateToJournal();
                                    },
                                  );
                                }
                              }
                            }
                          : null,
                      child: Text(
                        _currentIndex == questions.length - 1 ? 'Lihat Hasil Asesmen' : 'Lanjut',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
