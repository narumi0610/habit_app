import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/model/entities/habit/habit_model.dart';
import 'package:habit_app/model/use_cases/motivation_message_provider.dart';
import 'package:habit_app/model/use_cases/notification_setting_providers.dart';
import 'package:habit_app/model/use_cases/update_status_provider.dart';
import 'package:habit_app/presentation/widgets/update_button.dart';
import 'package:habit_app/utils/app_color.dart';
import 'package:habit_app/utils/global_const.dart';

class MockNotificationSettingNotifier extends NotificationSettingNotifier {
  @override
  Future<void> rescheduleNotification(HabitModel? habit) async {}
}

void main() {
  final date = DateTime(2024);
  group('UpdateButton Tests 🔄', () {
    late HabitModel testHabit;
    const buttonWidth = 200.0;

    setUp(() {
      testHabit = HabitModel(
        id: '1',
        userId: 'test_user',
        title: 'Test Habit',
        startDate: date,
        currentStreak: 5,
        completedFlg: 0,
        createdAt: date,
        updatedAt: date,
        deletedAt: null,
        deleted: 0,
      );
    });

    Future<void> pumpTestWidget(
      WidgetTester tester, {
      required HabitModel habit,
      required bool isUpdated,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isUpdatedTodayProvider.overrideWith(
              (ref, params) => isUpdated,
            ),
            motivationMessageStateProvider
                .overrideWith((ref) => 'Test message'),
            notificationSettingNotifierProvider
                .overrideWith(MockNotificationSettingNotifier.new),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: UpdateButton(
                habit: habit,
                width: buttonWidth,
              ),
            ),
          ),
        ),
      );
      // アニメーションが完全に終了するまで待機
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    RoundedProgressPainter? findProgressPainter(WidgetTester tester) {
      final customPaints =
          tester.widgetList<CustomPaint>(find.byType(CustomPaint)).toList();
      for (final paint in customPaints) {
        if (paint.painter is RoundedProgressPainter) {
          return paint.painter! as RoundedProgressPainter;
        }
      }
      return null;
    }

    testWidgets('renders with correct initial state', (tester) async {
      await pumpTestWidget(tester, habit: testHabit, isUpdated: false);

      // ボタンが存在することを確認
      expect(find.byType(UpdateButton), findsOneWidget);

      // 現在の連続日数が表示されていることを確認
      expect(find.text('5'), findsOneWidget);

      // プログレスインジケーターが存在することを確認
      final painter = findProgressPainter(tester);
      expect(painter, isNotNull);
    });

    testWidgets('shows correct progress indicator color when not updated',
        (tester) async {
      await pumpTestWidget(tester, habit: testHabit, isUpdated: false);

      final painter = findProgressPainter(tester);
      expect(painter, isNotNull);
      expect(painter?.progressColor, Colors.grey);
    });

    testWidgets('shows correct progress indicator color when updated',
        (tester) async {
      await pumpTestWidget(tester, habit: testHabit, isUpdated: true);

      final painter = findProgressPainter(tester);
      expect(painter, isNotNull);
      expect(painter?.progressColor, AppColor.primary);
    });

    testWidgets('calculates progress correctly', (tester) async {
      final habit = HabitModel(
        id: '1',
        userId: 'test_user',
        title: 'Test Habit',
        startDate: date,
        currentStreak: GlobalConst.maxContinuousDays ~/ 2, // 50%の進捗
        completedFlg: 0,
        createdAt: date,
        updatedAt: date,
        deletedAt: null,
        deleted: 0,
      );

      await pumpTestWidget(tester, habit: habit, isUpdated: false);

      final painter = findProgressPainter(tester);
      expect(painter, isNotNull);
      expect(painter?.progress, 0.5);
    });
  });
}
