import 'package:flutter_test/flutter_test.dart';
import 'package:project_judi/models/assessment_model.dart';
import 'package:project_judi/services/app_state_service.dart';
import 'package:project_judi/core/utils/formatters.dart';

void main() {
  group('RuangPulih Logic & Service Tests', () {
    test('Currency Formatter formats Rupiah correctly', () {
      expect(Formatters.formatRupiah(1500000), 'Rp 1.500.000');
      expect(Formatters.formatRupiah(25000), 'Rp 25.000');
      expect(Formatters.formatRupiah(0), 'Rp 0');
    });

    test('Assessment score calculation maps to correct addiction levels', () {
      expect(AssessmentResult.calculateLevel(2), AddictionLevel.ringan);
      expect(AssessmentResult.calculateLevel(4), AddictionLevel.sedang);
      expect(AssessmentResult.calculateLevel(8), AddictionLevel.berat);
    });

    test('AppStateService toggles anonymous mode correctly', () {
      final appState = AppStateService();
      expect(appState.currentUser.isAnonymous, true);

      appState.toggleAnonymousMode();
      expect(appState.currentUser.isAnonymous, false);

      appState.toggleAnonymousMode();
      expect(appState.currentUser.isAnonymous, true);
    });

    test('AppStateService adds journal entry and increments streak', () {
      final appState = AppStateService();
      final initialStreak = appState.currentUser.currentStreak;
      final initialJournalCount = appState.journals.length;

      appState.addJournalEntry(
        mood: 5,
        note: 'Hari yang luar biasa produktif tanpa judi.',
        trigger: 'Tidak ada pemicu',
      );

      expect(appState.currentUser.currentStreak, initialStreak + 1);
      expect(appState.journals.length, initialJournalCount + 1);
      expect(appState.journals.first.mood, 5);
    });

    test('Loss calculation simulation returns accurate projections', () {
      final appState = AppStateService();
      final sim = appState.calculateLossSimulation(dailyDeposit: 100000);

      expect(sim['monthly'], 3000000.0);
      expect(sim['yearly'], 36500000.0);
      expect(sim['fiveYears'], 182500000.0);
      expect((sim['equivalentItems'] as List).isNotEmpty, true);
    });
  });
}
