import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/presentation/widgets/error_dialog.dart';

void main() {
  group('ErrorDialog Tests ⚠️', () {
    testWidgets('shows error dialog with correct message', (tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () => showErrorDialog(context, errorMessage),
                child: const Text('Show Error'),
              );
            },
          ),
        ),
      );

      // エラーダイアログを表示
      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      // ダイアログのタイトルが表示されることを確認
      expect(find.text('エラーが発生しました'), findsOneWidget);

      // エラーメッセージが表示されることを確認
      expect(find.text(errorMessage), findsOneWidget);

      // OKボタンが表示されることを確認
      expect(find.text('OK'), findsOneWidget);

      // OKボタンをタップしてダイアログを閉じる
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // ダイアログが閉じられたことを確認
      expect(find.text('エラーが発生しました'), findsNothing);
    });
  });
}
