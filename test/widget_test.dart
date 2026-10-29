import 'package:flutter_test/flutter_test.dart';
import 'package:silog_app/main.dart';

void main() {
  testWidgets('SiLogApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SiLogApp());
    expect(find.text('Daftar Pengiriman'), findsOneWidget);
  });
}
