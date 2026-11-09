import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../models/user_model.dart';
import '../../services/app_state_service.dart';

class ProfileScreen extends StatelessWidget {
  final AppStateService appState;

  const ProfileScreen({super.key, required this.appState});

  void _showCertificateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFDE68A), width: 2),
              ),
              child: const Text('🏅', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 16),
            const Text(
              'SERTIFIKAT PENCAPAIAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Color(0xFF92400E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              appState.currentUser.publicDisplayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Telah berkomitmen teguh dan berhasil meraih ${appState.currentUser.currentStreak} Hari Bersih Bebas Judi Online serta menyelamatkan ${Formatters.formatRupiah(appState.currentUser.savedMoney)}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Terverifikasi oleh Komunitas RuangPulih • 2026',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sertifikat berhasil diunduh ke galeri! 🏅'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.share_rounded, size: 16),
                label: const Text('Bagikan / Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final user = appState.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('Profil & Privasi'),
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(user.avatar, style: const TextStyle(fontSize: 34)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.publicDisplayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.isAnonymous ? 'Nama samaran aktif (Identitas Asli Aman)' : user.email,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.displayName,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Gamification Badges
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Koleksi Lencana Pemulihan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text('4/6 Terbuka', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBadgeItem('🌱', '1 Hari', 'Langkah Awal', true),
                        _buildBadgeItem('🔥', '7 Hari', 'Satu Pekan', true),
                        _buildBadgeItem('⚡', '14 Hari', 'Dua Minggu', true),
                        _buildBadgeItem('💎', '30 Hari', 'Satu Bulan', false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Toggle Anonim
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  title: const Text(
                    'Privasi Mode Anonim',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                  ),
                  subtitle: Text(
                    user.isAnonymous
                        ? 'Nama asli kamu aman terlindungi di forum & chat'
                        : 'Nama asli kamu akan tampil',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                  value: user.isAnonymous,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => appState.toggleAnonymousMode(),
                ),
              ),
              const SizedBox(height: 12),

              // Sertifikat Pemulihan Button
              InkWell(
                onTap: () => _showCertificateDialog(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 22),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lihat Sertifikat Pemulihan',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                            ),
                            Text(
                              'Apresiasi hari bersih bebas judi online',
                              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Role Switcher (untuk Kemudahan Demo / Uji Coba)
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
                    const Text(
                      'Ganti Role (Demo Evaluasi)',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pilih peran untuk melihat perspektif berbeda aplikasi:',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: UserRole.values.map((r) {
                        final isSelected = user.role == r;
                        return ChoiceChip(
                          label: Text(r.displayName),
                          selected: isSelected,
                          selectedColor: AppColors.primaryContainer,
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                          ),
                          onSelected: (selected) {
                            if (selected) appState.switchRole(r);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  '${AppConstants.appName} v1.0.0 (2026)\n${AppConstants.appTagline}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeItem(String emoji, String days, String name, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: unlocked ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked ? AppColors.primary.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              unlocked ? emoji : '🔒',
              style: TextStyle(fontSize: unlocked ? 24 : 18),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          days,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 9.5,
            color: unlocked ? AppColors.textSecondary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
