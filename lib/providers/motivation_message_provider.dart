import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/services/gemini_service.dart';
import 'package:habit_app/utils/global_const.dart';

// AIコメントの状態を管理
final motivationMessageStateProvider =
    StateProvider<String>((ref) => GlobalConst.defaultMotivationMessage);

final motivationMessageProvider = FutureProvider.autoDispose.family<String,
    ({String habitTitle, int currentStreak, String lastCompletion})>(
  (ref, params) async {
    final geminiService = ref.watch(geminiServiceProvider);
    try {
      final message = geminiService.generateHabitMotivation(
        habitName: params.habitTitle,
        currentStreak: params.currentStreak,
        lastCompletion: params.lastCompletion,
      );
      return message;
    } catch (e) {
      return GlobalConst.defaultMotivationMessage;
    }
  },
);
