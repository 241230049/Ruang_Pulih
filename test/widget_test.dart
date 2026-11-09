import 'package:flutter_test/flutter_test.dart';
import 'package:project_judi/main.dart';
import 'package:project_judi/services/app_state_service.dart';

void main() {
  testWidgets('RuangPulih app loads splash screen smoke test', (WidgetTester tester) async {
    final appState = AppStateService();
    await tester.pumpWidget(RuangPulihApp(appState: appState));

    expect(find.text('RuangPulih'), findsOneWidget);
    expect(find.text('Mulai Pemulihan Sekarang'), findsOneWidget);
  });
}
