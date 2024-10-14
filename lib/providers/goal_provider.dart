import 'package:habit_app/repositories/habit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goal_provider.g.dart';

@riverpod
Future<void> setGoal(SetGoalRef ref, {required String form}) async {
  final repository = ref.read(habitRepositoryProvider);
  try {
    await repository.createHabit(title: form);
  } catch (e) {
    throw Exception('ViewModelでの目標設定に失敗しました: $e');
  }
}
