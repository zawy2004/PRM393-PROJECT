// Smoke test: Splash hiển thị rồi tự chuyển sang Login.

import 'package:flutter_test/flutter_test.dart';

import 'package:mealora/main.dart';

void main() {
  testWidgets('Splash -> Login flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MealoraApp());

    // Splash hiển thị tên app.
    expect(find.text('MealPrep'), findsOneWidget);

    // Sau ~2.5s tự chuyển sang màn Login.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Chào mừng bạn!'), findsOneWidget);
  });
}
