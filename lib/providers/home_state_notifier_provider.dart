import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/repositories/habit_repository.dart';

final homeAsyncNotifierProvider =
    AsyncNotifierProvider<HomeAsyncNotifier, HabitModel?>(
  HomeAsyncNotifier.new,
);

class HomeAsyncNotifier extends AsyncNotifier<HabitModel?> {
  @override
  FutureOr<HabitModel?> build() async {
    return await getCurrentHabit();
  }

  Future<HabitModel?> getCurrentHabit() async {
    final habit = await ref.read(habitRepositoryProvider).getCurrentHabit();
    return habit;
  }

  // 習慣を更新する
  Future<void> updateHabitDays(String habitId, int currentStreak) async {

    
    await ref
        .read(habitRepositoryProvider)
        .updateHabitDays(habitId, currentStreak);
  }

  
}
