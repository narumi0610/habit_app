import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/widgets/goal_item.dart';

class GoalHistoryScreen extends StatefulWidget {
  @override
  _GoalHistoryScreenState createState() => _GoalHistoryScreenState();
}

class _GoalHistoryScreenState extends State<GoalHistoryScreen> {
  List<Habit> _completedHabits = [];

  @override
  void initState() {
    super.initState();
    _getCompletedHabits();
  }

  // 完了した習慣を取得
  Future<void> _getCompletedHabits() async {
    _completedHabits = realm.all<Habit>().where((habit) {
      return habit.currentState >= 30;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _completedHabits.length,
          itemBuilder: (context, index) {
            return GoalItem(habit: _completedHabits[index]);
          },
        ),
      ),
    );
  }
}
