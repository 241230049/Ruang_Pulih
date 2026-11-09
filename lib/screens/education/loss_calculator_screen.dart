import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../services/app_state_service.dart';

class LossCalculatorScreen extends StatefulWidget {
  final AppStateService appState;

  const LossCalculatorScreen({super.key, required this.appState});

  @override
  State<LossCalculatorScreen> createState() => _LossCalculatorScreenState();
}

class _LossCalculatorScreenState extends State<LossCalculatorScreen> {
  double _dailyDeposit = 50000;

  final List<double> _quickPresets = const [
    25000,
    50000,
    100000,
    200000,
  ];

  @override
  Widget build(BuildContext context) {
    final monthly = _dailyDeposit * 30;
    final yearly = _dailyDeposit * 365;
    final fiveYears = yearly * 5;

    // Menghitung barang konkret yang relevan untuk anak muda (17-30 tahun)
    final int coffeeCups = (yearly / 25000).floor();
    final int uktSemesters = (yearly / 4500000).floor();
    final int iphones = (yearly / 18000000).floor();
    final int motorMatic = (yearly / 24000000).floor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Kalkulator Uang Nyata'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Banner intro
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Text('💸', style: TextStyle(fontSize: 34)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Berapa yang Bisa Kamu Selamatkan?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Nominal kecil harian kalau diakumulasi bisa beli impian nyata kamu.',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Slider & Preset Chips
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Biasa Deposit Berapa per Hari?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatters.formatRupiah(_dailyDeposit),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.danger,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text('/ hari', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 12),
                Slider(
                  value: _dailyDeposit,
                  min: 10000,
                  max: 500000,
                  divisions: 49,
                  activeColor: AppColors.danger,
                  inactiveColor: const Color(0xFFFFE4E6),
                  onChanged: (val) {
                    setState(() => _dailyDeposit = val);
                  },
                ),
                const SizedBox(height: 8),
                // Quick preset buttons
                Wrap(
                  spacing: 8,
                  children: _quickPresets.map((p) {
                    final isSelected = _dailyDeposit == p;
                    return InkWell(
                      onTap: () => setState(() => _dailyDeposit = p),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFE4E6) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.danger : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          Formatters.formatRupiah(p),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.danger : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Proyeksi Kerugian
          const Text(
            'Uang yang Lenyap Jika Diteruskan:',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildPeriodCard(
                  title: '1 Bulan',
                  amount: monthly,
                  color: AppColors.warning,
                  bgColor: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPeriodCard(
                  title: '1 Tahun',
                  amount: yearly,
                  color: AppColors.danger,
                  bgColor: const Color(0xFFFFE4E6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildPeriodCard(
            title: '5 Tahun (Bisa Beli Rumah / Modal Bisnis!)',
            amount: fiveYears,
            color: const Color(0xFF991B1B),
            bgColor: const Color(0xFFFEE2E2),
            isWide: true,
          ),
          const SizedBox(height: 24),

          // Ekuivalen Barang Impian Nyata
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🎯', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 10),
                    Text(
                      'Uang 1 Tahun Kamu Sebanding Dengan:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildEquivRow('🎓', 'Kuliah', uktSemesters > 0 ? '$uktSemesters Semester UKT Kuliah Lunas' : 'Biaya Kuliah & Buku'),
                if (iphones > 0)
                  _buildEquivRow('📱', 'Gadget', '$iphones Unit iPhone / Laptop Spek Tinggi'),
                if (motorMatic > 0)
                  _buildEquivRow('🛵', 'Kendaraan', '$motorMatic Unit Motor Matic Baru Cash'),
                _buildEquivRow('☕', 'Lifestyle', '$coffeeCups Gelas Kopi / Nongkrong Santai'),
                _buildEquivRow('📈', 'Investasi', 'Tabungan Emas Murni Aman Masa Depan'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Aksi
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Keputusan tepat! Ayo pertahankan streak bersih kamu hari ini! 🔥'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_rounded, size: 20),
              label: const Text('Komitmen: Stop Sekarang Juga!'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPeriodCard({
    required String title,
    required double amount,
    required Color color,
    required Color bgColor,
    bool isWide = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatRupiah(amount),
            style: TextStyle(
              fontSize: isWide ? 22 : 18,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquivRow(String emoji, String tag, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
