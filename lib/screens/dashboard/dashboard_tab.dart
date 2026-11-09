import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/assessment_model.dart';
import '../../services/app_state_service.dart';
import 'emergency_sheet.dart';
import '../assessment/assessment_screen.dart';
import '../assessment/assessment_result_sheet.dart';
import '../education/loss_calculator_screen.dart';

class DashboardTab extends StatefulWidget {
  final AppStateService appState;
  final Function(int) onNavigateToTab;

  const DashboardTab({
    super.key,
    required this.appState,
    required this.onNavigateToTab,
  });

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  int? _quickMoodSelected;

  final List<Map<String, dynamic>> _quickMoods = const [
    {'mood': 1, 'emoji': '😫', 'label': 'Down'},
    {'mood': 2, 'emoji': '😔', 'label': 'Cemas'},
    {'mood': 3, 'emoji': '😐', 'label': 'Netral'},
    {'mood': 4, 'emoji': '🙂', 'label': 'Tenang'},
    {'mood': 5, 'emoji': '💪', 'label': 'Kuat'},
  ];

  void _handleQuickMood(int mood, String label) {
    setState(() => _quickMoodSelected = mood);
    widget.appState.addJournalEntry(
      mood: mood,
      note: 'Check-in cepat: Merasa $label hari ini.',
      trigger: 'Tidak ada pemicu',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🔥 ', style: TextStyle(fontSize: 18)),
            Expanded(
              child: Text(
                'Mood $label tercatat! Streak kamu naik jadi ${widget.appState.currentUser.currentStreak} hari! 🚀',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final user = widget.appState.currentUser;
        final assessment = widget.appState.lastAssessmentResult;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Top Header: User Greeting + SOS Button
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        user.avatar,
                        style: const TextStyle(fontSize: 22),
                      ),
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
                                  user.publicDisplayName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (user.isAnonymous) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Anonim',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Satu hari lebih dekat ke kebebasan 🌱',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SOS Urgent Button
                    InkWell(
                      onTap: () => EmergencySheet.show(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFECDD3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: AppColors.danger,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'SOS',
                              style: TextStyle(
                                color: AppColors.danger,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Hero Streak Card (Gamified & Modern)
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F766E).withValues(alpha: 0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Text('🔥 ', style: TextStyle(fontSize: 12)),
                                Text(
                                  'Clean Streak',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF34D399)
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Text(
                              '🛑 Anti Judol',
                              style: TextStyle(
                                color: Color(0xFFA7F3D0),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text('🏆', style: TextStyle(fontSize: 32)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${user.currentStreak}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Hari Bersih!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '💸 ${Formatters.formatRupiah(user.savedMoney)} berhasil diselamatkan',
                                  style: const TextStyle(
                                    color: Color(0xFFCCFBF1),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick 1-Tap Mood Check-in (Gen Z Friendly)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Gimana Mood Kamu Hari Ini?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _quickMoodSelected != null
                                ? '✅ Tercatat'
                                : 'Tap 1 detik',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: _quickMoodSelected != null
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _quickMoods.map((m) {
                          final isSelected = _quickMoodSelected == m['mood'];
                          return InkWell(
                            onTap: () => _handleQuickMood(
                              m['mood'] as int,
                              m['label'] as String,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    m['emoji'] as String,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    m['label'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Action Grid (Clean, Rounded, Colorful)
                const Text(
                  'Fitur Utama RuangPulih',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModernActionCard(
                        icon: Icons.speed_rounded,
                        color: const Color(0xFF0284C7),
                        bgColor: const Color(0xFFE0F2FE),
                        title: 'Tes SOGS',
                        desc: 'Cek level adiksi',
                        tag: '3 Menit',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AssessmentScreen(
                                appState: widget.appState,
                                onNavigateToConsultation: () =>
                                    widget.onNavigateToTab(3),
                                onNavigateToJournal: () =>
                                    widget.onNavigateToTab(1),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernActionCard(
                        icon: Icons.calculate_rounded,
                        color: const Color(0xFFE11D48),
                        bgColor: const Color(0xFFFFE4E6),
                        title: 'Kalkulator',
                        desc: 'Duit yang selamat',
                        tag: 'Simulasi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LossCalculatorScreen(
                                appState: widget.appState,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModernActionCard(
                        icon: Icons.forum_rounded,
                        color: const Color(0xFF7C3AED),
                        bgColor: const Color(0xFFEDE9FE),
                        title: 'Curhat Anonim',
                        desc: 'Bebas stigma',
                        tag: 'Menfess',
                        onTap: () => widget.onNavigateToTab(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernActionCard(
                        icon: Icons.support_agent_rounded,
                        color: const Color(0xFF0D9488),
                        bgColor: const Color(0xFFCCFBF1),
                        title: 'Teman Cerita',
                        desc: 'Konselor sebaya',
                        tag: 'Gratis',
                        onTap: () => widget.onNavigateToTab(3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Status Diagnosa SOGS (Compact & Clear)
                if (assessment != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: assessment.level == AddictionLevel.berat
                                ? const Color(0xFFFFE4E6)
                                : (assessment.level == AddictionLevel.sedang
                                      ? const Color(0xFFFEF3C7)
                                      : const Color(0xFFD1FAE5)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.analytics_rounded,
                            color: assessment.level == AddictionLevel.berat
                                ? AppColors.danger
                                : (assessment.level == AddictionLevel.sedang
                                      ? AppColors.warning
                                      : AppColors.success),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assessment.level.title,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Skor: ${assessment.totalScore}/10 • Ketuk untuk tips',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            AssessmentResultSheet.show(
                              context,
                              result: assessment,
                              onConsultationPressed: () =>
                                  widget.onNavigateToTab(3),
                              onJournalPressed: () => widget.onNavigateToTab(1),
                            );
                          },
                          child: const Text(
                            'Buka',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Relatable SOS Callout Banner
                InkWell(
                  onTap: () => EmergencySheet.show(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text('🧘', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lagi Kepikiran Mau Depo?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Jeda 1 menit. Tarik napas & buka hotline darurat gratis.',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white70,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernActionCard({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String title,
    required String desc,
    required String tag,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
