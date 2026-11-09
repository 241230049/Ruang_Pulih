/// Konstanta aplikasi RuangPulih
class AppConstants {
  AppConstants._();

  static const String appName = 'RuangPulih';
  static const String appTagline = 'Karena Pemulihan Butuh Komunitas';
  static const String appSlogan = '🛑 STOP JUDOL — Bersama Kita Pulih 🛑';

  // Hotline Resmi Indonesia
  static const List<Map<String, String>> emergencyHotlines = [
    {
      'title': 'Kemenkes RI (Konseling Sejiwa)',
      'number': '119 ext 8',
      'desc': 'Layanan konseling psikologis gratis dari Kementerian Kesehatan RI',
      'icon': 'phone_in_talk',
    },
    {
      'title': 'Satgas PASTI (OJK - Pemberantasan Pinjol & Judol)',
      'number': '157',
      'desc': 'Pengaduan rekening judol, pinjaman online ilegal & investigasi keuangan',
      'icon': 'shield',
    },
    {
      'title': 'Into The Light Indonesia',
      'number': 'www.intothelightid.org',
      'desc': 'Pendampingan krisis depresi, keputusasaan & pencegahan bunuh diri',
      'icon': 'favorite',
    },
    {
      'title': 'Bareskrim Polri (Aduan Siber)',
      'number': 'patrolisiber.id',
      'desc': 'Pelaporan situs, agen promosi, dan rekening deposit judi online',
      'icon': 'policy',
    },
  ];

  // Kategori Forum Anonim
  static const List<String> forumCategories = [
    'Semua',
    'Dukungan Emosional',
    'Cerita Sukses',
    'Tergoda (Urge)',
    'Utang & Finansial',
    'Tanya Konselor',
  ];

  // Quotes Motivasi Pemulihan
  static const List<String> recoveryQuotes = [
    '"Pemulihan bukan soal tidak pernah jatuh, tapi soal selalu bangkit dengan dukungan orang-orang yang peduli."',
    '"Uang yang hilang tidak bisa dikembalikan dengan berjudi lagi. Namun masa depan Anda masih bisa diselamatkan hari ini."',
    '"Satu hari bebas judi adalah satu langkah nyata menuju kebebasan dan kedamaian hidup."',
    '"Kemenangan terbesar dari judi online adalah ketika Anda memutuskan untuk berhenti selamanya."',
    '"Jangan biarkan algoritma mesin menghancurkan impian nyata dan martabat keluarga Anda."',
  ];
}

