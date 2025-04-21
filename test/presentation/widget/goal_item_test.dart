import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/model/entities/habit/habit_model.dart';
import 'package:habit_app/presentation/widgets/goal_item.dart';

void main() {
  group('GoalItem Tests 🎯', () {
    final date = DateTime(2024);
    final testHabit = HabitModel(
      id: '1',
      userId: 'test_user',
      title: 'Test Habit',
      startDate: date,
      currentStreak: 0,
      completedFlg: 1,
      createdAt: date,
      updatedAt: date,
      deletedAt: null,
      deleted: 0,
    );

    testWidgets('renders habit title and dates correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalItem(habit: testHabit),
          ),
        ),
      );

      // タイトルが表示されることを確認
      expect(find.text('目標: Test Habit'), findsOneWidget);

      // 開始日が表示されることを確認
      expect(find.text('開始日: 2024/01/01'), findsOneWidget);

      // 完了日が表示されることを確認（completedFlgが1の場合）
      expect(find.text('終了日: 2024/01/01'), findsOneWidget);
    });

    testWidgets('hides completion date when habit is not completed',
        (tester) async {
      final uncompletedHabit = HabitModel(
        id: '2',
        userId: 'test_user',
        title: 'Uncompleted Habit',
        startDate: date,
        currentStreak: 0,
        completedFlg: 0,
        createdAt: date,
        updatedAt: date,
        deletedAt: null,
        deleted: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalItem(habit: uncompletedHabit),
          ),
        ),
      );

      // タイトルと開始日は表示される
      expect(find.text('目標: Uncompleted Habit'), findsOneWidget);
      expect(find.text('開始日: 2024/01/01'), findsOneWidget);

      // 完了日は表示されない
      expect(find.text('終了日: 2024/01/01'), findsNothing);
    });
  });
}
