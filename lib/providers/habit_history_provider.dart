import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/repositories/habit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_history_provider.g.dart';

@riverpod
Future<List<HabitModel?>> getHabitHistory(GetHabitHistoryRef ref) async {
  final repository = ref.read(habitRepositoryProvider);
  try {
    final habitHistory = await repository.getHabitHistory();
    return habitHistory;
  } catch (e) {
    throw Exception('ViewModelでの習慣履歴の取得に失敗しました: $e');
  }
}
