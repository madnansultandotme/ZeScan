// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:zescan/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ZeScanApp());

    // Verify that onboarding details are displayed.
    expect(find.text('ZeScan'), findsWidgets);
    expect(find.text('The scanner that respects you.'), findsOneWidget);
    expect(find.text('Scan My First Document'), findsOneWidget);
  });
}
