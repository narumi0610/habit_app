import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/presentation/widgets/custom_text_field.dart';
import 'package:habit_app/utils/app_color.dart';

void main() {
  group('CustomTextField Tests 📝', () {
    testWidgets('renders text field with label', (tester) async {
      final controller = TextEditingController();
      const labelText = 'Test Label';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
                text: labelText,
                validator: null,
              ),
            ),
          ),
        ),
      );

      // ラベルテキストが表示されることを確認
      expect(find.text(labelText), findsOneWidget);

      // テキストフィールドのスタイルを確認
      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.cursorColor, equals(AppColor.primary));
    });

    testWidgets('password field toggles visibility', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
                text: 'Password',
                validator: null,
                isPassword: true,
              ),
            ),
          ),
        ),
      );

      // パスワードが初期状態で非表示になっていることを確認
      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, isTrue);

      // 表示/非表示切り替えボタンが存在することを確認
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // ボタンをタップして表示状態を切り替え
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // パスワードが表示状態になったことを確認
      final updatedTextField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );
      expect(updatedTextField.obscureText, isFalse);
    });

    testWidgets('validates input correctly', (tester) async {
      final controller = TextEditingController();
      const errorMessage = 'Required field';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Form(
                child: CustomTextField(
                  controller: controller,
                  text: 'Test',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return errorMessage;
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // フォームを検証
      final formState = tester.state<FormState>(find.byType(Form));
      expect(formState.validate(), isFalse);

      // エラーメッセージが表示されることを確認
      await tester.pump();
      expect(find.text(errorMessage), findsOneWidget);

      // テキストを入力して再検証
      await tester.enterText(find.byType(TextFormField), 'Test Input');
      expect(formState.validate(), isTrue);
    });
  });
}
