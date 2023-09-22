import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalItem extends StatelessWidget {
  // final Habit habit;

  @override
  Widget build(BuildContext context) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('目標: ${habit.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('開始日: ', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            // Text('終了日: ${habit.endDate()}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
