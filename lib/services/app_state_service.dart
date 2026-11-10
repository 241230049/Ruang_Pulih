import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../models/assessment_model.dart';
import '../models/journal_model.dart';
import '../models/forum_model.dart';
import '../models/volunteer_model.dart';
import '../models/consultation_model.dart';
import '../models/donation_model.dart';
import '../models/education_model.dart';

class AppStateService extends ChangeNotifier {
  // Current User
  UserModel _currentUser = UserModel(
    id: 'user_001',
    name: 'Rian Pratama',
    email: 'rian.pejuang@gmail.com',
    role: UserRole.korban,
    isAnonymous: true,
    aliasName: 'Pejuang Pulih #8812',
    avatar: '🌱',
    currentStreak: 0,
    savedMoney: 3600000,
    createdAt: DateTime(2026, 10, 15),
  );

  UserModel get currentUser => _currentUser;

  // Toggle mode anonim
  void toggleAnonymousMode() {
    _currentUser = _currentUser.copyWith(
      isAnonymous: !_currentUser.isAnonymous,
    );
    notifyListeners();
  }

  // Switch role (untuk testing/demo korban, volunteer, admin)
  void switchRole(UserRole newRole) {
    _currentUser = _currentUser.copyWith(role: newRole);
    notifyListeners();
  }

  void updateAvatar(String newAvatar) {
    _currentUser = _currentUser.copyWith(avatar: newAvatar);
    notifyListeners();
  }

  void updateAliasName(String newAlias) {
    _currentUser = _currentUser.copyWith(aliasName: newAlias);
    notifyListeners();
  }

  // Update streak & saved money
  void incrementStreak() {
    _currentUser = _currentUser.copyWith(
      currentStreak: _currentUser.currentStreak + 1,
      savedMoney:
          _currentUser.savedMoney + 150000, // rata-rata hemat 150rb/hari
    );
    notifyListeners();
  }

  // -------------------------------------------------------------
  // ASESMEN SOGS (South Oaks Gambling Screen)
  // -------------------------------------------------------------
  final List<AssessmentQuestion> _sogsQuestions = const [
    AssessmentQuestion(
      id: 1,
      category: 'Pola Perilaku',
      question: 'Seberapa sering Anda merasa dorongan yang sangat kuat untuk bermain judi online (slot, tebak angka, kasino online)?',
      options: [
        AssessmentOption(text: 'Tidak pernah / Sangat jarang', score: 0),
        AssessmentOption(
          text: 'Kadang-kadang saat sedang bosan/stres',
          score: 1,
        ),
        AssessmentOption(
          text: 'Sering, hampir setiap hari terpikirkan',
          score: 2,
        ),
      ],
    ),
    AssessmentQuestion(
      id: 2,
      category: 'Chasing Losses',
      question: 'Ketika Anda mengalami kekalahan uang, apakah Anda kembali bermain di hari lain untuk "mengembalikan modal" yang hilang?',
      options: [
        AssessmentOption(
          text: 'Tidak, saya menerima kekalahan dan berhenti',
          score: 0,
        ),
        AssessmentOption(text: 'Kadang-kadang mencoba sekali lagi', score: 1),
        AssessmentOption(
          text: 'Selalu, saya merasa harus mengembalikan uang itu',
          score: 2,
        ),
      ],
    ),
    AssessmentQuestion(
      id: 3,
      category: 'Privasi & Rahasia',
      question: 'Apakah Anda pernah berbohong kepada orang tua, pasangan, atau teman dekat mengenai jumlah uang dan waktu yang dihabiskan untuk judi online?',
      options: [
        AssessmentOption(text: 'Tidak pernah berbohong', score: 0),
        AssessmentOption(
          text: 'Pernah menyembunyikan nominal sebagian',
          score: 1,
        ),
        AssessmentOption(
          text: 'Sering berbohong demi menutupi jejak transaksi',
          score: 2,
        ),
      ],
    ),
    AssessmentQuestion(
      id: 4,
      category: 'Finansial & Utang',
      question: 'Apakah Anda pernah meminjam uang dari pinjol (pinjaman online), teman, atau menggadaikan barang berharga demi modal deposit?',
      options: [
        AssessmentOption(text: 'Tidak pernah sama sekali', score: 0),
        AssessmentOption(
          text: 'Pernah meminjam nominal kecil ke teman dekat',
          score: 1,
        ),
        AssessmentOption(
          text: 'Ya, terlilit pinjol ilegal atau menjual barang berharga',
          score: 2,
        ),
      ],
    ),
    AssessmentQuestion(
      id: 5,
      category: 'Dampak Akademik & Sosial',
      question: 'Apakah kebiasaan ini mengganggu konsentrasi belajar, kuliah, pekerjaan, atau membuat Anda merasa cemas dan sulit tidur?',
      options: [
        AssessmentOption(text: 'Tidak ada gangguan signifikan', score: 0),
        AssessmentOption(
          text: 'Kadang sulit fokus dan merasa bersalah',
          score: 1,
        ),
        AssessmentOption(
          text: 'Sangat mengganggu, sering insomnia dan putus asa',
          score: 2,
        ),
      ],
    ),
  ];

  List<AssessmentQuestion> get sogsQuestions => _sogsQuestions;

  AssessmentResult? _lastAssessmentResult = AssessmentResult(
    id: 'as_init',
    userId: 'user_001',
    totalScore: 4,
    level: AddictionLevel.sedang,
    takenAt: DateTime(2026, 10, 18),
    selectedAnswers: {1: 1, 2: 1, 3: 1, 4: 0, 5: 1},
  );

  AssessmentResult? get lastAssessmentResult => _lastAssessmentResult;

  void saveAssessmentResult(Map<int, int> answers) {
    int total = 0;
    answers.forEach((_, score) => total += score);
    final level = AssessmentResult.calculateLevel(total);

    _lastAssessmentResult = AssessmentResult(
      id: 'as_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser.id,
      totalScore: total,
      level: level,
      takenAt: DateTime.now(),
      selectedAnswers: answers,
    );
    notifyListeners();
  }

  // -------------------------------------------------------------
  // JURNAL PEMULIHAN
  // -------------------------------------------------------------
  final List<JournalEntry> _journals = [
    JournalEntry(
      id: 'j_1',
      userId: 'user_001',
      mood: 5,
      note: 'Hari ke-18. Berhasil melewati akhir pekan tanpa buka situs judi. Ikut olahraga lari santai bersama teman kampus.',
      trigger: 'Tidak ada pemicu',
      dayStreak: 18,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    JournalEntry(
      id: 'j_2',
      userId: 'user_001',
      mood: 4,
      note: 'Sempat muncul iklan pop-up di Telegram, tapi langsung saya laporkan dan tutup. Fokus kerjakan revisi skripsi.',
      trigger: 'Iklan Medsos / Telegram',
      dayStreak: 17,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    JournalEntry(
      id: 'j_3',
      userId: 'user_001',
      mood: 3,
      note: 'Merasa agak cemas saat melihat saldo tabungan, tapi bersyukur sudah mulai mencicil utang secara jujur.',
      trigger: 'Kekhawatiran Finansial',
      dayStreak: 16,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    JournalEntry(
      id: 'j_4',
      userId: 'user_001',
      mood: 4,
      note: 'Konseling dengan Kak Nabila (volunteer psikologi) sangat membuka mata. Saya sadar saya tidak sendirian.',
      trigger: 'Tidak ada pemicu',
      dayStreak: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<JournalEntry> get journals => _journals;

  void addJournalEntry({
    required int mood,
    required String note,
    required String trigger,
  }) {
    final newEntry = JournalEntry(
      id: 'j_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser.id,
      mood: mood,
      note: note,
      trigger: trigger,
      dayStreak: _currentUser.currentStreak + 1,
      createdAt: DateTime.now(),
    );
    _journals.insert(0, newEntry);
    incrementStreak();
    notifyListeners();
  }

  // -------------------------------------------------------------
  // FORUM ANONIM
  // -------------------------------------------------------------
  final List<ForumPost> _forumPosts = [
    ForumPost(
      id: 'fp_1',
      userId: 'user_992',
      authorName: 'Pejuang Bebas #4401',
      isAnonymous: true,
      title: 'Sudah 40 hari bersih! Rasanya damai sekali bisa tidur nyenyak.',
      content:
          'Dulu setiap jam 2 pagi mata masih melotot mandangin layar hp nunggu putaran slot. Uang semesteran habis, hidup penuh kebohongan. '
          'Bulan lalu saya putuskan hapus m-banking sementara dan serahkan ke ibu. Awalnya berat sekali, tremor dan gelisah. '
          'Tapi hari ini, kepala saya plong. Teman-teman pejuang di RuangPulih, kalian pasti bisa lewati fase ini!',
      category: 'Cerita Sukses',
      likes: 42,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      comments: [
        ForumComment(
          id: 'fc_1',
          postId: 'fp_1',
          userId: 'user_881',
          authorName: 'Sahabat Tenang #1109',
          content: 'Terima kasih bang sharingnya! Sangat menguatkan saya yang baru hari ke-5 ini.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ForumComment(
          id: 'fc_2',
          postId: 'fp_1',
          userId: 'user_001',
          authorName: 'Pejuang Pulih #8812',
          content: 'Luar biasa! Tidur nyenyak adalah kemewahan yang kita rasakan setelah lepas dari lingkaran setan ini.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    ForumPost(
      id: 'fp_2',
      userId: 'user_773',
      authorName: 'Anonim Kampus #293',
      isAnonymous: true,
      title: 'Tergoda pas lihat teman tongkrongan menang jackpot 2 juta',
      content:
          'Tadi sore pas kumpul di warkop, ada teman yang pamer dapet wd 2 juta. Otak saya langsung bisikin "coba 50rb doang". '
          'Untung saya inget komitmen streak di RuangPulih dan langsung pamit pulang. Ada tips nggak buat ngadepin lingkungan toxic kaya gini?',
      category: 'Tergoda (Urge)',
      likes: 19,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 7)),
      comments: [
        ForumComment(
          id: 'fc_3',
          postId: 'fp_2',
          userId: 'user_552',
          authorName: 'Langkah Baru #712',
          content: 'Ingat bro: Menang itu cuma pancingan bandar agar kita setor 10x lipat di kemudian hari. Keputusanmu pamit udah bener banget!',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ],
    ),
    ForumPost(
      id: 'fp_3',
      userId: 'user_331',
      authorName: 'Pejuang Pulih #004',
      isAnonymous: true,
      title:
          'Cara negosiasi utang pinjol akibat judol tanpa bikin keluarga syok',
      content:
          'Saya mahasiswa semester 7. Terjebak utang 12 juta di 3 aplikasi legal karena judol. '
          'Kemarin saya beranikan diri bicara jujur dengan orang tua sambil bawa catatan rekening koran. Ternyata orang tua mau bantu cari solusi asalkan saya janji hapus total dan dampingi konseling. Jangan dipendam sendiri teman-teman.',
      category: 'Utang & Finansial',
      likes: 35,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      comments: [],
    ),
  ];

  List<ForumPost> get forumPosts => _forumPosts;

  void toggleLikePost(String postId) {
    final index = _forumPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _forumPosts[index];
      final newIsLiked = !post.isLiked;
      final newLikes = newIsLiked ? post.likes + 1 : post.likes - 1;
      _forumPosts[index] = post.copyWith(isLiked: newIsLiked, likes: newLikes);
      notifyListeners();
    }
  }

  void addPost({
    required String title,
    required String content,
    required String category,
    required bool isAnonymous,
  }) {
    final newPost = ForumPost(
      id: 'fp_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser.id,
      authorName: isAnonymous ? _currentUser.aliasName : _currentUser.name,
      isAnonymous: isAnonymous,
      title: title,
      content: content,
      category: category,
      likes: 0,
      isLiked: false,
      comments: [],
      createdAt: DateTime.now(),
    );
    _forumPosts.insert(0, newPost);
    notifyListeners();
  }

  void addComment(String postId, String content) {
    final index = _forumPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _forumPosts[index];
      final newComment = ForumComment(
        id: 'fc_${DateTime.now().millisecondsSinceEpoch}',
        postId: postId,
        userId: _currentUser.id,
        authorName: _currentUser.publicDisplayName,
        isAnonymous: _currentUser.isAnonymous,
        content: content,
        createdAt: DateTime.now(),
      );
      final updatedComments = List<ForumComment>.from(post.comments)
        ..add(newComment);
      _forumPosts[index] = post.copyWith(comments: updatedComments);
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // VOLUNTEER & KONSELINE
  // -------------------------------------------------------------
  final List<VolunteerProfile> _volunteers = const [
    VolunteerProfile(
      id: 'vol_1',
      userId: 'user_v1',
      name: 'Nabila Safira, S.Psi (Kandidat Magister)',
      university: 'Universitas Indonesia (UI)',
      faculty: 'Fakultas Psikologi',
      bio: 'Fokus pada Cognitive Behavioral Therapy (CBT) untuk adiksi perilaku dan pemulihan trauma utang bagi mahasiswa.',
      skills: ['CBT Adiksi', 'Konseling Emosional', 'Relapse Prevention'],
      availableDays: ['Senin', 'Rabu', 'Jumat', 'Sabtu'],
      isVerified: true,
      rating: 4.95,
      consultationCount: 42,
      avatarUrl: '👩‍⚕️',
    ),
    VolunteerProfile(
      id: 'vol_2',
      userId: 'user_v2',
      name: 'Fauzan Hidayat',
      university: 'Universitas Pendidikan Indonesia (UPI)',
      faculty: 'Bimbingan dan Konseling (BK)',
      bio: 'Pendamping sebaya ramah, mendengarkan tanpa menghakimi, membantu pemulihan motivasi belajar mahasiswa.',
      skills: ['Peer Counseling', 'Manajemen Stres', 'Literasi Finansial'],
      availableDays: ['Selasa', 'Kamis', 'Sabtu'],
      isVerified: true,
      rating: 4.88,
      consultationCount: 31,
      avatarUrl: '👨‍🎓',
    ),
    VolunteerProfile(
      id: 'vol_3',
      userId: 'user_v3',
      name: 'Sarah Rahmadani, S.Psi',
      university: 'Universitas Gadjah Mada (UGM)',
      faculty: 'Psikologi Klinis',
      bio: 'Membantu korban mengatasi rasa bersalah, insomnia akibat kecemasan, dan rekonsiliasi hubungan dengan keluarga.',
      skills: ['Trauma Healing', 'Family Therapy Support', 'Mindfulness'],
      availableDays: ['Rabu', 'Jumat', 'Minggu'],
      isVerified: true,
      rating: 4.98,
      consultationCount: 56,
      avatarUrl: '👩‍🏫',
    ),
  ];

  List<VolunteerProfile> get volunteers => _volunteers;

  final List<ConsultationSession> _consultations = [
    ConsultationSession(
      id: 'cs_1',
      korbanId: 'user_001',
      korbanName: 'Pejuang Pulih #8812',
      volunteerId: 'vol_1',
      volunteerName: 'Nabila Safira, S.Psi',
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '19:30 - 20:30 WIB',
      consultationType: 'Chat Anonim',
      status: ConsultationStatus.disetujui,
      notes: 'Sesi lanjutan pendampingan dorongan craving minggu ke-3.',
      messages: [
        ChatMessage(
          id: 'cm_1',
          senderId: 'vol_1',
          senderName: 'Kak Nabila',
          isFromUser: false,
          text: 'Halo kak Rian! Selamat atas hari ke-18 ya. Bagaimana perasaannya hari ini?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          id: 'cm_2',
          senderId: 'user_001',
          senderName: 'Pejuang Pulih #8812',
          isFromUser: true,
          text: 'Halo Kak Nabila. Alhamdulillah jauh lebih tenang. Sempat ada pemicu kemarin tapi berhasil dialihkan ke jogging.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 45),
          ),
        ),
        ChatMessage(
          id: 'cm_3',
          senderId: 'vol_1',
          senderName: 'Kak Nabila',
          isFromUser: false,
          text: 'Bagus sekali teknik grounding-nya! Nanti di sesi besok kita akan bahas cara memperkuat benteng finansial ya.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 30),
          ),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<ConsultationSession> get consultations => _consultations;

  void bookConsultation({
    required VolunteerProfile volunteer,
    required DateTime date,
    required String timeSlot,
    required String notes,
    required String type,
  }) {
    final newSession = ConsultationSession(
      id: 'cs_${DateTime.now().millisecondsSinceEpoch}',
      korbanId: _currentUser.id,
      korbanName: _currentUser.publicDisplayName,
      volunteerId: volunteer.id,
      volunteerName: volunteer.name,
      scheduledDate: date,
      timeSlot: timeSlot,
      consultationType: type,
      status: ConsultationStatus.disetujui,
      notes: notes,
      messages: [
        ChatMessage(
          id: 'cm_welcome',
          senderId: volunteer.id,
          senderName: volunteer.name,
          isFromUser: false,
          text: 'Halo! Sesi konsultasi Anda telah dijadwalkan. Ruang ini adalah tempat aman dan rahasia untuk bercerita. Silakan ketik pesan jika ada yang ingin Anda tanyakan terlebih dahulu.',
          timestamp: DateTime.now(),
        ),
      ],
      createdAt: DateTime.now(),
    );
    _consultations.insert(0, newSession);
    notifyListeners();
  }

  void sendConsultationMessage(String sessionId, String text) {
    final index = _consultations.indexWhere((c) => c.id == sessionId);
    if (index != -1) {
      final session = _consultations[index];
      final userMsg = ChatMessage(
        id: 'cm_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUser.id,
        senderName: _currentUser.publicDisplayName,
        isFromUser: true,
        text: text,
        timestamp: DateTime.now(),
      );

      final updatedMessages = List<ChatMessage>.from(session.messages)
        ..add(userMsg);
      _consultations[index] = session.copyWith(messages: updatedMessages);
      notifyListeners();

      // Simulasi auto-reply ramah dari volunteer setelah 1 detik
      Future.delayed(const Duration(milliseconds: 1200), () {
        final volunteerReply = ChatMessage(
          id: 'cm_reply_${DateTime.now().millisecondsSinceEpoch}',
          senderId: session.volunteerId,
          senderName: session.volunteerName,
          isFromUser: false,
          text: 'Terima kasih sudah berbagi. Saya mendengarkan Anda. Ingat, setiap langkah kecil pemulihan ini sangat berarti.',
          timestamp: DateTime.now(),
        );
        final listWithReply = List<ChatMessage>.from(
          _consultations[index].messages,
        )..add(volunteerReply);
        _consultations[index] = _consultations[index].copyWith(
          messages: listWithReply,
        );
        notifyListeners();
      });
    }
  }

  // -------------------------------------------------------------
  // DONASI TRANSPARAN
  // -------------------------------------------------------------
  final List<DonationCampaign> _campaigns = [
    DonationCampaign(
      id: 'camp_1',
      title: 'Bantuan Darurat Pendampingan Psikologis & Hukum Mahasiswa Terjerat Judol & Pinjol',
      category: 'Bantuan Hukum & Psikologis',
      targetAmount: 25000000,
      currentAmount: 18750000,
      story:
          'Banyak mahasiswa terpaksa putus kuliah dan mendapat teror debt collector akibat terjebak pusaran promosi judi online ilegal. '
          'Donasi ini digunakan 100% transparan untuk membiayai sesi konseling psikolog profesional eksternal, advokasi hukum pemblokiran rekening debt collector nakal, serta operasional safe-house.',
      donorCount: 142,
      organizer: 'Satgas Pemulihan Sosial RuangPulih',
      createdAt: DateTime(2026, 9, 1),
      distributions: const [
        FundDistribution(
          id: 'dist_1',
          title: 'Honorarium Sesi Konseling Psikolog Klinis (8 Mahasiswa)',
          amount: 4000000,
          date: '01 Nov 2026',
          recipient: 'Lembaga Psikologi Mitra',
          description: 'Penyaluran sesi CBT intensif untuk 8 korban dengan indikasi depresi berat.',
        ),
        FundDistribution(
          id: 'dist_2',
          title: 'Bantuan Advokasi Hukum Teror Pinjol Ilegal',
          amount: 2500000,
          date: '24 Okt 2026',
          recipient: 'Lembaga Bantuan Hukum Kampus',
          description:
              'Mediasi dan pelaporan pidana pemerasan ke Satgas PASTI OJK.',
        ),
      ],
      recentDonations: [
        DonationItem(
          id: 'don_1',
          campaignId: 'camp_1',
          donorName: 'Hamba Allah',
          isAnonymous: true,
          amount: 500000,
          message: 'Semoga adik-adik mahasiswa lekas pulih dan kembali menata masa depan.',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        DonationItem(
          id: 'don_2',
          campaignId: 'camp_1',
          donorName: 'Alumni Peduli UI',
          isAnonymous: false,
          amount: 1500000,
          message:
              'Bersama kita selamatkan generasi muda dari bahaya judi online.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    DonationCampaign(
      id: 'camp_2',
      title: 'Pengadaan Modul Literasi Digital & Kampanye Anti-Judol di 20 Kampus Daerah',
      category: 'Edukasi & Pencegahan',
      targetAmount: 15000000,
      currentAmount: 9400000,
      story: 'Pencegahan adalah kunci. Kami mencetak dan mendistribusikan buku saku pemulihan, infografis bahaya algoritma gacor, serta workshop interaktif langsung di kampus-kampus.',
      donorCount: 78,
      organizer: 'Komunitas Relawan RuangPulih',
      createdAt: DateTime(2026, 10, 1),
      distributions: const [
        FundDistribution(
          id: 'dist_3',
          title: 'Cetak Buku Saku "Bebas dari Jeratan Slot" (500 Eksemplar)',
          amount: 3200000,
          date: '28 Okt 2026',
          recipient: 'Percetakan Kampus Edukasi',
          description:
              'Distribusi gratis saat seminar kesehatan mental mahasiswa baru.',
        ),
      ],
      recentDonations: [],
    ),
  ];

  List<DonationCampaign> get campaigns => _campaigns;

  void donateToCampaign({
    required String campaignId,
    required double amount,
    required String donorName,
    required bool isAnonymous,
    required String message,
  }) {
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      final camp = _campaigns[index];
      final newDonation = DonationItem(
        id: 'don_${DateTime.now().millisecondsSinceEpoch}',
        campaignId: campaignId,
        donorName: isAnonymous ? 'Donatur Anonim' : donorName,
        isAnonymous: isAnonymous,
        amount: amount,
        message: message.isEmpty
            ? 'Semoga bermanfaat bagi pemulihan sesama.'
            : message,
        createdAt: DateTime.now(),
      );

      final updatedDonations = List<DonationItem>.from(camp.recentDonations)
        ..insert(0, newDonation);
      _campaigns[index] = camp.copyWith(
        currentAmount: camp.currentAmount + amount,
        donorCount: camp.donorCount + 1,
        recentDonations: updatedDonations,
      );
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // EDUKASI & LITERASI
  // -------------------------------------------------------------
  final List<EducationalContent> _educationalContents = const [
    EducationalContent(
      id: 'edu_1',
      title: 'Bongkar Trik Bandar: Mengapa "Pola Gacor" dan "Jam Hoki" Itu Murni Ilusi',
      category: 'Psikologi & Teknologi',
      readTime: '4 menit baca',
      author: 'Tim Riset RuangPulih',
      publishedDate: '02 Nov 2026',
      isFeatured: true,
      summary: 'Mesin slot online diatur oleh algoritma RNG (Random Number Generator) dan RTP (Return to Player) yang secara matematis dirancang agar pemain selalu rugi dalam jangka panjang.',
      body:
          'Banyak pemain percaya rumor mengenai "pola putaran", "jam hoki subuh", atau "bocoran admin". '
          'Fakta ilmiah membuktikan bahwa algoritma Random Number Generator (RNG) menghasilkan jutaan kombinasi angka per detik yang tidak memiliki memori masa lalu.\n\n'
          'Setiap kali Anda menekan tombol spin, peluang kemenangan selalu di bawah 10%, sementara persentase keuntungan bandar (House Edge) dipastikan mencapai 90-95%.\n\n'
          'Fenomena "Near-Miss" (hampir menang) sengaja diprogram untuk merangsang produksi hormon dopamin di otak, memicu ilusi bahwa Anda "sedikit lagi menang", padahal itu hanyalah umpan agar uang Anda terkuras habis.',
    ),
    EducationalContent(
      id: 'edu_2',
      title: 'Teknik STOP: Cara Menghentikan Dorongan (Craving) Saat Ingin Deposit Lagi',
      category: 'Strategi Pemulihan',
      readTime: '3 menit baca',
      author: 'Fauzan Hidayat (Konselor)',
      publishedDate: '29 Okt 2026',
      isFeatured: true,
      summary: 'Dorongan ingin berjudi biasanya mencapai puncak dalam 10-15 menit pertama. Ketahui cara menjeda reaksi otak sebelum terlambat.',
      body:
          'Saat keinginan deposit muncul:\n\n'
          '1. S - Stop (Berhenti Seketika): Jangan sentuh aplikasi m-banking atau e-wallet. Tarik napas dalam 4 detik, tahan 4 detik, hembuskan 4 detik.\n'
          '2. T - Take a breath (Alihkan Tubuh): Segera cuci muka dengan air dingin atau berdiri dan jalan keluar ruangan.\n'
          '3. O - Observe (Amati Emosi): Tanya ke diri sendiri, "Apakah saya sedang bosan, lelah, kesepian, atau marah?". Judi seringkali pelarian dari masalah emosional.\n'
          '4. P - Proceed (Langkah Positif): Buka RuangPulih, catat perasaan di Jurnal, atau telepon teman terdekat.',
    ),
    EducationalContent(
      id: 'edu_3',
      title: 'Jerat Hukum & Bahaya Pinjol Ilegal yang Mendanai Judi Online',
      category: 'Hukum & Finansial',
      readTime: '5 menit baca',
      author: 'Satgas Hukum Mahasiswa',
      publishedDate: '20 Okt 2026',
      isFeatured: false,
      summary: 'Pasal 303 KUHP dan UU ITE melarang segala bentuk perjudian. Pelajari hak perlindungan konsumen jika mengalami teror penyebaran data pribadi.',
      body:
          'Judi online dan pinjaman online ilegal adalah dua sisi mata uang yang menghancurkan masa depan finansial.\n\n'
          'OJK dan Satgas PASTI menegaskan bahwa korban penipuan atau pemerasan pinjol berhak mendapatkan perlindungan hukum. '
          'Segera laporkan nomor debt collector nakal dan jangan pernah meminjam uang di tempat baru untuk menutup utang lama (gali lubang tutup lubang).',
    ),
  ];

  List<EducationalContent> get educationalContents => _educationalContents;

  // -------------------------------------------------------------
  // SIMULASI KALKULATOR KERUGIAN
  // -------------------------------------------------------------
  Map<String, dynamic> calculateLossSimulation({required double dailyDeposit}) {
    final double monthly = dailyDeposit * 30;
    final double sixMonths = dailyDeposit * 180;
    final double yearly = dailyDeposit * 365;
    final double fiveYears = yearly * 5;

    // Perbandingan ekuivalen barang bermanfaat
    List<String> items = [];
    if (yearly >= 30000000) {
      items = [
        '1 Unit Motor Matic Baru',
        'Biaya Kuliah (UKT) 4 Semester Penuh',
        'Modal Usaha Franchise UMKM',
      ];
    } else if (yearly >= 15000000) {
      items = [
        'Laptop Gaming / Desain Spek Tinggi',
        'Biaya Kuliah (UKT) 2-3 Semester',
        'Dana Darurat Keluarga untuk 6 Bulan',
      ];
    } else {
      items = [
        'Smartphone Baru untuk Kebutuhan Produktif',
        'Biaya Makan Bergizi 3-4 Bulan',
        'Investasi Emas Murni Tabungan Masa Depan',
      ];
    }

    return {
      'daily': dailyDeposit,
      'monthly': monthly,
      'sixMonths': sixMonths,
      'yearly': yearly,
      'fiveYears': fiveYears,
      'equivalentItems': items,
    };
  }
}
