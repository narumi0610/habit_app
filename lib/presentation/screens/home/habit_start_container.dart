import 'package:flutter/material.dart';
import 'package:habit_app/presentation/screens/home/set_goal_button.dart';

class HabitStartContainer extends StatelessWidget {
  const HabitStartContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const FittedBox(
                    child: Text(
                      '目標を設定しよう！',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SetGoalButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
