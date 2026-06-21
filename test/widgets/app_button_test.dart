import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';

void main() {
  testWidgets('AppButton shows label and responds to tap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Saqlash',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Saqlash'), findsOneWidget);
    await tester.tap(find.text('Saqlash'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('AppButton shows loading indicator and ignores presses', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Yuklanmoqda',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('AppButton disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Nofaol',
            onPressed: null,
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}
