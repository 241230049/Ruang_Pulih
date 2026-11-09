import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/donation_model.dart';
import '../../services/app_state_service.dart';

class DonateDialog extends StatefulWidget {
  final DonationCampaign campaign;
  final AppStateService appState;

  const DonateDialog({
    super.key,
    required this.campaign,
    required this.appState,
  });

  static void show(BuildContext context, {
    required DonationCampaign campaign,
    required AppStateService appState,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DonateDialog(campaign: campaign, appState: appState),
    );
  }

  @override
  State<DonateDialog> createState() => _DonateDialogState();
}

class _DonateDialogState extends State<DonateDialog> {
  double _selectedNominal = 50000;
  bool _isAnonymous = true;
  final TextEditingController _customNominalController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();

  final List<double> _predefinedNominals = const [
    25000,
    50000,
    100000,
    250000,
  ];

  @override
  void dispose() {
    _customNominalController.dispose();
    _msgController.dispose();
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
            const Text(
              'Donasi Bantuan Bencana Sosial',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              widget.campaign.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // Pilihan Nominal
            const Text('Pilih Nominal Bantuan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _predefinedNominals.map((nom) {
                final isSelected = _selectedNominal == nom;
                return ChoiceChip(
                  label: Text(Formatters.formatRupiah(nom)),
                  selected: isSelected,
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        _selectedNominal = nom;
                        _customNominalController.clear();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customNominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Atau ketik nominal lainnya (Rp)...',
                prefixIcon: Icon(Icons.payments_outlined, color: AppColors.primary),
              ),
              onChanged: (val) {
                final parsed = double.tryParse(val.replaceAll('.', '').replaceAll(',', ''));
                if (parsed != null && parsed > 0) {
                  setState(() {
                    _selectedNominal = parsed;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Toggle Anonim Donatur
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _isAnonymous,
              title: const Text('Donasi Sebagai Hamba Allah (Anonim)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('Nama Anda tidak akan ditampilkan di daftar donatur publik', style: TextStyle(fontSize: 11.5)),
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isAnonymous = val ?? true),
            ),
            const SizedBox(height: 8),

            // Pesan Doa / Dukungan
            TextField(
              controller: _msgController,
              decoration: const InputDecoration(
                hintText: 'Tuliskan doa atau pesan penyemangat bagi para korban...',
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Salurkan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.appState.donateToCampaign(
                    campaignId: widget.campaign.id,
                    amount: _selectedNominal,
                    donorName: widget.appState.currentUser.name,
                    isAnonymous: _isAnonymous,
                    message: _msgController.text.trim(),
                  );
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Terima Kasih!'),
                        ],
                      ),
                      content: Text(
                        'Donasi sebesar ${Formatters.formatRupiah(_selectedNominal)} telah tercatat dengan aman dan transparan di RuangPulih.',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
                label: Text('Salurkan ${Formatters.formatRupiah(_selectedNominal)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

