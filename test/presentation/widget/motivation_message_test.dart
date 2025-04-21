import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/model/use_cases/motivation_message_provider.dart';
import 'package:habit_app/model/use_cases/update_status_provider.dart';
import 'package:habit_app/presentation/widgets/motivation_message.dart';
import 'package:habit_app/utils/app_color.dart';

void main() {
  group('MotivationMessage Widget Tests 💭', () {
    testWidgets('MotivationMessage renders with correct message',
        (tester) async {
      const testMessage = 'Test motivation message';
      final now = DateTime.now();

      // テスト用のProviderScopeを作成
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // モチベーションメッセージのプロバイダーをオーバーライド
            motivationMessageStateProvider.overrideWith((ref) => testMessage),
            // 更新状態のプロバイダーをオーバーライド
            isUpdatedTodayProvider.overrideWith((ref, params) => true),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MotivationMessage(
                updatedAt: now,
                currentStreak: 1,
              ),
            ),
          ),
        ),
      );

      // メッセージが正しく表示されることを確認
      expect(find.text(testMessage.trim()), findsOneWidget);
    });

    testWidgets(
        'MotivationMessage changes background color based on update status',
        (tester) async {
      const testMessage = 'Test message';
      final now = DateTime.now();

      // 更新済みの場合のテスト
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            motivationMessageStateProvider.overrideWith((ref) => testMessage),
            isUpdatedTodayProvider.overrideWith((ref, params) => true),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MotivationMessage(
                updatedAt: now,
                currentStreak: 1,
              ),
            ),
          ),
        ),
      );

      // Bubbleウィジェットの色を確認
      final bubble = tester.widget<Bubble>(find.byType(Bubble));
      expect(
        bubble.color,
        AppColor.primary.withValues(alpha: 0.2),
      );
    });
  });
}
