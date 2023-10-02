import 'package:flutter/material.dart';
import 'package:habit_app/models/habit/habit_model.dart';

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
            const Text('開始日: ', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('終了日: ${habit.updated_at}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
