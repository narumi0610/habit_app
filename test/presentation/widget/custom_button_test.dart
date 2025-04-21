import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/presentation/widgets/custom_button.dart';
import 'package:habit_app/utils/app_color.dart';

void main() {
  group('CustomButton Widget Tests 🔘', () {
    testWidgets('CustomButton.primary renders correctly', (tester) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton.primary(
              onPressed: () => buttonPressed = true,
              isDisabled: false,
              loading: false,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // ボタンが存在することを確認
      expect(find.text('Test Button'), findsOneWidget);

      // プライマリカラーが設定されていることを確認
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, equals(AppColor.primary));

      // ボタンをタップしてコールバックが呼ばれることを確認
      await tester.tap(find.byType(CustomButton));
      expect(buttonPressed, isTrue);
    });

    testWidgets('CustomButton shows loading indicator when loading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton.primary(
              onPressed: () {},
              isDisabled: false,
              loading: true,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // ローディングインジケータが表示されることを確認
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // ボタンのテキストが表示されないことを確認
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('CustomButton is disabled when isDisabled is true',
        (tester) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton.primary(
              onPressed: () => buttonPressed = true,
              isDisabled: true,
              loading: false,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // ボタンをタップしてもコールバックが呼ばれないことを確認
      await tester.tap(find.byType(CustomButton));
      expect(buttonPressed, isFalse);
    });

    testWidgets('CustomButton.grey renders with correct style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton.grey(
              onPressed: () {},
              isDisabled: false,
              loading: false,
              child: const Text('Grey Button'),
            ),
          ),
        ),
      );

      // グレーボタンのスタイルが正しく設定されていることを確認
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, equals(Colors.grey.shade200));
    });
  });
}
