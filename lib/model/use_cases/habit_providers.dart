import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/entities/habit/habit_model.dart';
import 'package:habit_app/model/repositories/habit_repository.dart';
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
Future<AsyncValue<void>> updateHabitDays(
  Ref ref, {
  required String habitId,
  required int currentStreak,
}) async {
  return AsyncValue.guard(() async {
    await ref
        .read(habitRepositoryProvider)
        .updateHabitDays(habitId, currentStreak);
    ref
      // 更新したあと結果は使用しない
      // ignore: unused_result
      ..refresh(getCurrentHabitProvider)
      // 更新したあと結果は使用しない
      // ignore: unused_result
      ..refresh(getHabitHistoryProvider);
  });
}

@riverpod
Future<AsyncValue<void>> createHabit(Ref ref, {required String form}) async {
  return AsyncValue.guard(() async {
    await ref.read(habitRepositoryProvider).createHabit(title: form);
    // 更新したあと結果は使用しない
    // ignore: unused_result
    ref.refresh(getCurrentHabitProvider);
  });
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
