import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/repositories/habit_repository.dart';

class SetGoalStateNotifier extends StateNotifier<String> {
  SetGoalStateNotifier(this.repository) : super('');

  final HabitRepository repository;

  final TextEditingController controller = TextEditingController();

  Future<T> setGoal<T>({
    required String form,
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
    return await repository.createHabit(
      title: form,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}

final setGoalStateNotifierProvider =
    StateNotifierProvider<SetGoalStateNotifier, String>(
  (ref) => SetGoalStateNotifier(ref.read(habitRepositoryProvider)),
);
