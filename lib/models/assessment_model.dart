enum AddictionLevel {
  ringan,
  sedang,
  berat,
}

extension AddictionLevelExtension on AddictionLevel {
  String get title {
    switch (this) {
      case AddictionLevel.ringan:
        return 'Risiko Rendah / Fase Awal';
      case AddictionLevel.sedang:
        return 'Risiko Sedang (Problem Gambling)';
      case AddictionLevel.berat:
        return 'Kecanduan Berat (Pathological)';
    }
  }

  String get description {
    switch (this) {
      case AddictionLevel.ringan:
        return 'Anda menunjukkan sedikit tanda keterlibatan. Segera lakukan pencegahan agar tidak terjerumus lebih dalam ke lingkaran perjudian.';
      case AddictionLevel.sedang:
        return 'Pola perilaku judi mulai mengganggu kestabilan finansial dan emosi Anda. Sangat disarankan untuk memulai pendampingan konselor.';
      case AddictionLevel.berat:
        return 'Tingkat kecanduan sangat tinggi dan berisiko merusak masa depan, relasi keluarga, dan hukum. Dibutuhkan intervensi segera dan pendampingan intensif.';
    }
  }

  List<String> get recommendations {
    switch (this) {
      case AddictionLevel.ringan:
        return [
          'Hapus dan blokir semua aplikasi/link judi serta e-wallet terkait',
          'Mulai isi Jurnal Pemulihan harian di RuangPulih',
          'Alihkan waktu luang ke hobi baru atau komunitas olahraga/kampus',
        ];
      case AddictionLevel.sedang:
        return [
          'Batasi akses perbankan: serahkan kendali rekening darurat ke orang terpercaya',
          'Jadwalkan sesi konseling gratis dengan relawan mahasiswa RuangPulih',
          'Bergabung dan aktif bercerita di Forum Anonim sesama pejuang pulih',
          'Gunakan Kalkulator Kerugian untuk menyadari dampak finansial nyata',
        ];
      case AddictionLevel.berat:
        return [
          'Segera hubungi hotline darurat Kemenkes 119 ext 8 atau Into The Light',
          'Jadwalkan sesi pendampingan psikologis profesional melalui RuangPulih',
          'Lakukan transparansi utang dengan keluarga atau pihak berwenang',
          'Ikuti program tantangan 30 hari bersih bersama komunitas pendamping',
        ];
    }
  }
}

class AssessmentQuestion {
  final int id;
  final String question;
  final String category;
  final List<AssessmentOption> options;

  const AssessmentQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
  });
}

class AssessmentOption {
  final String text;
  final int score;

  const AssessmentOption({
    required this.text,
    required this.score,
  });
}

class AssessmentResult {
  final String id;
  final String userId;
  final int totalScore;
  final AddictionLevel level;
  final DateTime takenAt;
  final Map<int, int> selectedAnswers; // questionId -> score

  const AssessmentResult({
    required this.id,
    required this.userId,
    required this.totalScore,
    required this.level,
    required this.takenAt,
    required this.selectedAnswers,
  });

  static AddictionLevel calculateLevel(int score) {
    if (score <= 2) {
      return AddictionLevel.ringan;
    } else if (score <= 5) {
      return AddictionLevel.sedang;
    } else {
      return AddictionLevel.berat;
    }
  }
}

