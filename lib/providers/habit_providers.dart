import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/repositories/habit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_providers.g.dart';

@riverpod
Future<HabitModel?> getCurrentHabit(Ref ref) async {
  try {
    final habit = await ref.read(habitRepositoryProvider).getCurrentHabit();
    return habit;
  } catch (e) {
    throw Exception('ViewModelでの現在の習慣の取得に失敗しました $e');
  }
}

@riverpod
Future<void> updateHabitDays(
  Ref ref, {
  required String habitId,
  required int currentStreak,
}) async {
  try {
    await ref
        .read(habitRepositoryProvider)
        .updateHabitDays(habitId, currentStreak);
    ref
      // ignore: unused_result
      ..refresh(getCurrentHabitProvider)
      // ignore: unused_result
      ..refresh(getHabitHistoryProvider);
  } catch (e) {
    throw Exception('ViewModelでの習慣の継続更新に失敗しました $e');
  }
}

@riverpod
Future<void> createHabit(Ref ref, {required String form}) async {
  final repository = ref.read(habitRepositoryProvider);
  try {
    await repository.createHabit(title: form);
    // ignore: unused_result
    ref.refresh(getCurrentHabitProvider);
  } catch (e) {
    throw Exception('ViewModelでの目標設定に失敗しました: $e');
  }
}

@riverpod
Future<List<HabitModel?>> getHabitHistory(Ref ref) async {
  final repository = ref.read(habitRepositoryProvider);
  try {
    final habitHistory = await repository.getHabitHistory();
    return habitHistory;
  } catch (e) {
    throw Exception('ViewModelでの習慣履歴の取得に失敗しました: $e');
  }
}
