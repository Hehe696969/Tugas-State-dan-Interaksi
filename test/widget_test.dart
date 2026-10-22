
import 'package:flutter_test/flutter_test.dart';
import 'package:profil_mahasiswa_state/main.dart';

void main() {
  testWidgets('Aplikasi CampusHub tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const KampusApp());

    expect(find.text('KAMPUSKU'), findsOneWidget);
    expect(find.text('Profil Mahasiswa'), findsOneWidget);
    expect(find.text('Mochamad Basa'), findsOneWidget);
  });
}
