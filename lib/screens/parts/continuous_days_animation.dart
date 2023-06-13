import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class ContinuousDaysAnimation extends StatelessWidget {
  final int currentState;
  const ContinuousDaysAnimation(this.currentState, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedFlipCounter(
      duration: const Duration(seconds: 1),
      value: currentState,
      textStyle: const TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.bold,
        color: AppColor.text,
      ),
    );
  }
}
