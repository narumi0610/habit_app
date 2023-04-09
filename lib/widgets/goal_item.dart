import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';

class GoalItem extends StatelessWidget {
  final Habit habit;

  GoalItem({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('目標: ${habit.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('開始日: ${habit.startDate}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            // Text('終了日: ${habit.getEndDate()}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
