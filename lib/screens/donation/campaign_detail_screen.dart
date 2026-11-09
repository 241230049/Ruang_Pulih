import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/donation_model.dart';
import '../../services/app_state_service.dart';
import 'donate_dialog.dart';

class CampaignDetailScreen extends StatelessWidget {
  final String campaignId;
  final AppStateService appState;

  const CampaignDetailScreen({
    super.key,
    required this.campaignId,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final camp = appState.campaigns.firstWhere(
          (c) => c.id == campaignId,
          orElse: () => DonationCampaign(
            id: '',
            title: '',
            category: '',
            targetAmount: 0,
            currentAmount: 0,
            story: '',
            donorCount: 0,
            organizer: '',
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );

        if (camp.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Kampanye')),
            body: const Center(child: Text('Kampanye tidak ditemukan')),
          );
        }

        final percentage = (camp.progressPercentage * 100).toInt();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Bantuan & Donasi'),
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Badge Kategori
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    camp.category,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                camp.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 6),
              Text(
                'Digalang oleh: ${camp.organizer}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Progress Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatRupiah(camp.currentAmount),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Terkumpul dari target ${Formatters.formatRupiah(camp.targetAmount)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: camp.progressPercentage,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          '${camp.donorCount} Donatur Peduli',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cerita / Latar Belakang
              const Text(
                'Latar Belakang & Kisah Bantuan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                camp.story,
                style: const TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),

              // Laporan Transparansi Penggunaan Dana
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Transparansi Penyaluran Dana',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Semua dana diaudit dan disalurkan langsung ke mitra psikolog dan bantuan hukum terakreditasi.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),
                    if (camp.distributions.isEmpty)
                      const Text('Belum ada penyaluran termin pertama.')
                    else
                      ...camp.distributions.map((dist) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Formatters.formatRupiah(dist.amount),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.danger),
                                  ),
                                  Text(dist.date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dist.title,
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${dist.recipient} • ${dist.description}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Riwayat Donatur Terkini
              const Text(
                'Donatur Terkini',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              if (camp.recentDonations.isEmpty)
                const Text('Jadilah donatur pertama untuk campaign ini.', style: TextStyle(fontSize: 12, color: AppColors.textMuted))
              else
                ...camp.recentDonations.map((don) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          radius: 18,
                          child: Text(don.isAnonymous ? '🕊️' : '👤', style: const TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                don.donorName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                              ),
                              if (don.message.isNotEmpty)
                                Text(
                                  don.message,
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          Formatters.formatRupiah(don.amount),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 24),

              // Tombol Donasi Sekarang
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => DonateDialog.show(context, campaign: camp, appState: appState),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Donasi Sekarang'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
