import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../models/user_model.dart';
import '../../services/app_state_service.dart';

class ProfileScreen extends StatefulWidget {
  final AppStateService appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Daftar pilihan avatar pemulihan
  final List<Map<String, String>> _availableAvatars = const [
    {'emoji': '🌱', 'name': 'Tunas Baru', 'meaning': 'Awal mula kehidupan & harapan'},
    {'emoji': '🌿', 'name': 'Daun Segar', 'meaning': 'Pertumbuhan diri yang konsisten'},
    {'emoji': '🛡️', 'name': 'Perisai Pulih', 'meaning': 'Benteng pertahanan diri'},
    {'emoji': '🦅', 'name': 'Elang Bebas', 'meaning': 'Kemerdekaan dari jerat judi'},
    {'emoji': '🌊', 'name': 'Gelombang Tenang', 'meaning': 'Ketenangan batin & emosi'},
    {'emoji': '🌻', 'name': 'Bunga Harapan', 'meaning': 'Optimisme menatap masa depan'},
    {'emoji': '🧘', 'name': 'Mindful Spirit', 'meaning': 'Fokus dan kesadaran penuh'},
    {'emoji': '🕊️', 'name': 'Merpati Damai', 'meaning': 'Kedamaian bersama keluarga'},
    {'emoji': '⭐', 'name': 'Bintang Penuntun', 'meaning': 'Kompas hidup yang terarah'},
    {'emoji': '🔥', 'name': 'Api Semangat', 'meaning': 'Tekad membara untuk sembuh'},
    {'emoji': '💎', 'name': 'Permata Jiwa', 'meaning': 'Menghargai nilai diri sejati'},
    {'emoji': '🦁', 'name': 'Pemberani', 'meaning': 'Keberanian menghadapi tantangan'},
  ];

  // Daftar nama alias samaran
  final List<String> _aliasPrefixes = const [
    'Pejuang Pulih',
    'Lentera Tenang',
    'Ksatria Bangkit',
    'Bintang Harapan',
    'Napas Baru',
    'Arus Damai',
    'Fajar Pemulihan',
    'Langkah Teguh',
    'Jiwa Merdeka',
  ];

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const Text(
              'Pilih Avatar Pemulihan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih simbol yang mewakili perjalanan dan semangat pemulihanmu:',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.88,
                ),
                itemCount: _availableAvatars.length,
                itemBuilder: (context, index) {
                  final item = _availableAvatars[index];
                  final isSelected = widget.appState.currentUser.avatar == item['emoji'];
                  return InkWell(
                    onTap: () {
                      widget.appState.updateAvatar(item['emoji']!);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Avatar diubah menjadi ${item['name']} ${item['emoji']}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryContainer : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['emoji']!, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(
                            item['name']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateNewAlias() {
    final random = Random();
    final prefix = _aliasPrefixes[random.nextInt(_aliasPrefixes.length)];
    final number = 1000 + random.nextInt(9000);
    final newAlias = '$prefix #$number';
    widget.appState.updateAliasName(newAlias);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nama samaran baru: "$newAlias" 🛡️'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  void _showBadgeDetail({
    required String emoji,
    required String title,
    required String subtitle,
    required String description,
    required int requiredDays,
    required bool isUnlocked,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isUnlocked ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked ? const Color(0xFFFDE68A) : const Color(0xFFCBD5E1),
                  width: 3,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  isUnlocked ? emoji : '🔒',
                  style: TextStyle(fontSize: isUnlocked ? 40 : 32),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.successLight : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isUnlocked ? 'Terbuka ✓' : 'Terkunci',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isUnlocked ? const Color(0xFF047857) : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
                  ),
                ),
                if (isUnlocked) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lencana "$title" siap dibagikan! 🏆'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: const Text('Bagikan'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCertificateDialog(BuildContext context) {
    final user = widget.appState.currentUser;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Frame Luar Bergaya Sertifikat
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A), width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('★ ★ ★', style: TextStyle(color: Color(0xFFD97706), fontSize: 11)),
                      Text(
                        'ID: RP-${user.id.toUpperCase()}',
                        style: const TextStyle(fontSize: 10, color: Color(0xFFB45309), fontWeight: FontWeight.bold),
                      ),
                      const Text('★ ★ ★', style: TextStyle(color: Color(0xFFD97706), fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFF59E0B), width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🏅', style: TextStyle(fontSize: 30)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SERTIFIKAT PENGHARGAAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  const Text(
                    'RUANG PULIH INDONESIA',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: Color(0xFFB45309),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Diberikan dengan hormat kepada:',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.publicDisplayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Atas keteguhan tekad, keberanian, dan integritas dalam konsisten meraih ${user.currentStreak} Hari Bersih Bebas Judi Online serta menyelamatkan ${Formatters.formatRupiah(user.savedMoney)} demi martabat dan masa depan yang damai.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF78350F), height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Text(
                          'Resmi Terverifikasi Komunitas • ${Formatters.formatDate(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
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
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Unduh'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final user = widget.appState.currentUser;
        final streak = user.currentStreak;

        // Hitung progres level berikutnya (target 30 hari)
        final nextTargetDays = streak < 7 ? 7 : (streak < 14 ? 14 : (streak < 30 ? 30 : 60));
        final levelProgress = (streak / nextTargetDays).clamp(0.0, 1.0);

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('Profil & Privasi'),
            elevation: 0,
            actions: [
              IconButton(
                tooltip: 'Sertifikat',
                icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706)),
                onPressed: () => _showCertificateDialog(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // ========================================================
              // HERO PROFILE CARD
              // ========================================================
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Dekorasi lingkaran aksen belakang
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: -25,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          // Avatar dengan Tombol Edit
                          GestureDetector(
                            onTap: _showAvatarPicker,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(user.avatar, style: const TextStyle(fontSize: 42)),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Nama Pengguna
                          Text(
                            user.publicDisplayName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Status Privasi & Role Pill
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      user.isAnonymous ? Icons.shield_rounded : Icons.verified_user_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      user.isAnonymous ? 'Mode Anonim Aktif' : 'Publik Terverifikasi',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  user.role.displayName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 3 Metric Mini Cards
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildMetricItem(
                                    emoji: '🔥',
                                    title: '$streak Hari',
                                    subtitle: 'Hari Bebas',
                                  ),
                                ),
                                Container(
                                  height: 32,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                Expanded(
                                  child: _buildMetricItem(
                                    emoji: '🛡️',
                                    title: Formatters.formatRupiah(user.savedMoney),
                                    subtitle: 'Diselamatkan',
                                  ),
                                ),
                                Container(
                                  height: 32,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                Expanded(
                                  child: _buildMetricItem(
                                    emoji: '🌱',
                                    title: 'Level ${streak >= 30 ? "3" : (streak >= 14 ? "2" : "1")}',
                                    subtitle: 'Fase Pulih',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Level Pemulihan Progress Bar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Menuju Fase ${nextTargetDays >= 30 ? "Benteng Baja" : "Dua Minggu"}',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  Text(
                                    '$streak / $nextTargetDays Hari',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: levelProgress,
                                  minHeight: 7,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFDE68A)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ========================================================
              // KOLEKSI LENCANA PEMULIHAN
              // ========================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Koleksi Lencana Pemulihan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Sentuh lencana untuk melihat detail',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${(streak >= 30 ? 4 : (streak >= 14 ? 3 : (streak >= 7 ? 2 : (streak >= 1 ? 1 : 0))))} / 6 Terbuka',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBadgeCard(
                          emoji: '🌱',
                          title: '1 Hari',
                          subtitle: 'Langkah Awal',
                          desc: 'Langkah pertama dan paling berani untuk mengakui dan lepas dari jerat judi online.',
                          requiredDays: 1,
                          isUnlocked: streak >= 1,
                        ),
                        _buildBadgeCard(
                          emoji: '🔥',
                          title: '7 Hari',
                          subtitle: 'Satu Pekan',
                          desc: 'Melewati gelombang godaan dan fase penarikan diri awal selama 7 hari berturut-turut.',
                          requiredDays: 7,
                          isUnlocked: streak >= 7,
                        ),
                        _buildBadgeCard(
                          emoji: '⚡',
                          title: '14 Hari',
                          subtitle: 'Dua Minggu',
                          desc: 'Membentuk kebiasaan sehat baru dan mengembalikan kendali emosi serta keuangan.',
                          requiredDays: 14,
                          isUnlocked: streak >= 14,
                        ),
                        _buildBadgeCard(
                          emoji: '🛡️',
                          title: '30 Hari',
                          subtitle: 'Satu Bulan',
                          desc: 'Benteng baja sebulan penuh bebas judol. Titik balik penting dalam transformasi hidup.',
                          requiredDays: 30,
                          isUnlocked: streak >= 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ========================================================
              // KARTU SERTIFIKAT PRESTISIUs (GOLD BANNER)
              // ========================================================
              InkWell(
                onTap: () => _showCertificateDialog(context),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                        ),
                        child: const Text('🏅', style: TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Sertifikat Pemulihan Resmi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: Color(0xFF78350F),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD97706),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'SIAP',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Apresiasi hari bersih & ${Formatters.formatRupiah(user.savedMoney)} dana terselamatkan',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF92400E)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFFD97706)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ========================================================
              // PENGATURAN PRIVASI & IDENTITAS
              // ========================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield_outlined, size: 20, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Privasi & Identitas Akun',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Switch Mode Anonim
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mode Anonim Komunitas',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.isAnonymous
                                      ? 'Nama asli & email kamu disembunyikan'
                                      : 'Nama asli kamu akan tampil di publik',
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: user.isAnonymous,
                            activeTrackColor: AppColors.primary,
                            onChanged: (val) => widget.appState.toggleAnonymousMode(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Preview Identitas Publik
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined, size: 16, color: AppColors.primaryDark),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tampil di Forum & Chat Sebagai:',
                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                ),
                                Text(
                                  user.publicDisplayName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          if (user.isAnonymous)
                            IconButton(
                              tooltip: 'Acak Nama Samaran',
                              icon: const Icon(Icons.casino_rounded, color: AppColors.primaryDark),
                              onPressed: _generateNewAlias,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Garansi Keamanan Data
                    Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF10B981)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Data curhat, asesmen, dan jurnalmu terenkripsi secara lokal.',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ========================================================
              // ROLE SWITCHER (DEMO EVALUASI)
              // ========================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.swap_horiz_rounded, size: 20, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Ganti Peran (Demo Evaluasi)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pilih perspektif peran pengguna untuk menguji fitur aplikasi:',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    // 3 Role Cards
                    _buildRoleOption(
                      role: UserRole.korban,
                      title: 'Pejuang Pulih',
                      desc: 'Akses penuh asesmen, tracker bersih, forum dan ruang curhat.',
                      icon: Icons.person_outline_rounded,
                      currentRole: user.role,
                    ),
                    const SizedBox(height: 8),
                    _buildRoleOption(
                      role: UserRole.volunteer,
                      title: 'Volunteer Konselor',
                      desc: 'Merespon sesi konsultasi, pendampingan krisis & validasi pejuang.',
                      icon: Icons.volunteer_activism_outlined,
                      currentRole: user.role,
                    ),
                    const SizedBox(height: 8),
                    _buildRoleOption(
                      role: UserRole.admin,
                      title: 'Admin RuangPulih',
                      desc: 'Moderasi forum, verifikasi donasi & analisis data komunitas.',
                      icon: Icons.admin_panel_settings_outlined,
                      currentRole: user.role,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ========================================================
              // FOOTER & BRANDING
              // ========================================================
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🌱', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          ' v1.0.0 (2026)',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppConstants.appTagline,
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricItem({
    required String emoji,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required String emoji,
    required String title,
    required String subtitle,
    required String desc,
    required int requiredDays,
    required bool isUnlocked,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showBadgeDetail(
          emoji: emoji,
          title: title,
          subtitle: subtitle,
          description: desc,
          requiredDays: requiredDays,
          isUnlocked: isUnlocked,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isUnlocked ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnlocked ? AppColors.primary.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? emoji : '🔒',
                    style: TextStyle(fontSize: isUnlocked ? 22 : 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? AppColors.primaryDark : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required UserRole role,
    required String title,
    required String desc,
    required IconData icon,
    required UserRole currentRole,
  }) {
    final isSelected = currentRole == role;
    return InkWell(
      onTap: () => widget.appState.switchRole(role),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
