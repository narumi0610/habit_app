import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/services/gemini_service.dart';
import 'package:habit_app/utils/global_const.dart';

// AIコメントの状態を管理
final motivationMessageStateProvider =
    StateProvider<String>((ref) => GlobalConst.defaultMotivationMessage);

final motivationMessageProvider = FutureProvider.autoDispose.family<String,
    ({String habitTitle, int currentStreak, String lastCompletion})>(
  (ref, habitModel) async {
    final geminiService = ref.watch(geminiServiceProvider);
    try {
      final message = await geminiService.generateHabitMotivation(
        habitName: habitModel.habitTitle,
        currentStreak: habitModel.currentStreak,
        lastCompletion: habitModel.lastCompletion,
      );
      return message;
    } catch (e) {
      return GlobalConst.defaultMotivationMessage;
    }
  },
);
