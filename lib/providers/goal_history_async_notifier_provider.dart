import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/repositories/habit_repository.dart';

final goalHistoryAsyncNotifierProvider =
    AsyncNotifierProvider<GoalHistoryAsyncNotifier, List<HabitModel?>>(
  GoalHistoryAsyncNotifier.new,
);

class GoalHistoryAsyncNotifier extends AsyncNotifier<List<HabitModel?>> {
  @override
  FutureOr<List<HabitModel?>> build() async {
    return await ref.read(habitRepositoryProvider).getHabitHistory();
  }
}
