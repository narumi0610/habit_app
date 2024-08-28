import 'package:flutter/material.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/utils/format.dart';

class GoalItem extends StatelessWidget {
  final HabitModel habit;
  const GoalItem({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('目標: ${habit.title}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('開始日: ${Format.yyyymmdd(habit.created_at)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Visibility(
              visible: habit.completed_flg == 1,
              child: Text('終了日: ${Format.yyyymmdd(habit.updated_at)}',
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
