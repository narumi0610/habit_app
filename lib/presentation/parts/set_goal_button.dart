import 'package:flutter/material.dart';
import 'package:habit_app/presentation/screens/create_habit_screen.dart';
import 'package:habit_app/utils/rounded_button.dart';

class SetGoalButton extends StatelessWidget {
  const SetGoalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: '目標を設定する',
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<CreateHabitScreen>(
            builder: (context) => const CreateHabitScreen(),
          ),
        );
      },
    );
  }
}
