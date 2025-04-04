import 'package:flutter/material.dart';
import 'package:habit_app/model/entities/habit/habit_model.dart';
import 'package:habit_app/utils/format.dart';

class GoalItem extends StatelessWidget {
  const GoalItem({
    required this.habit,
    super.key,
  });
  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('目標: ${habit.title}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              '開始日: ${Format.yyyymmdd(habit.createdAt)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Visibility(
              visible: habit.completedFlg == 1,
              child: Text(
                '終了日: ${Format.yyyymmdd(habit.updatedAt)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
