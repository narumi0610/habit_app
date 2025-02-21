import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:habit_app/utils/global_const.dart';
import '../providers/gemini_provider.dart';
import '../utils/prompts/habit_support_prompts.dart';

class GeminiService {
  GeminiService(this._gemini);
  final GenerativeModel _gemini;

  // 習慣の応援コメントを生成
  Future<String> generateHabitMotivation({
    required String habitName,
    required int currentStreak,
    String? lastCompletion,
  }) async {
    final prompt = HabitSupportPrompts.generateDailyMotivation(
      habitName: habitName,
      currentStreak: currentStreak + 1,
      lastCompletion: lastCompletion,
    );

    try {
      final content = [Content.text(prompt)];
      final response = await _gemini.generateContent(content);

      return response.text ?? GlobalConst.defaultMotivationMessage;
    } catch (e) {
      return GlobalConst.defaultMotivationMessage;
    }
  }
}

// Providerの定義
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final gemini = ref.watch(geminiProvider);

  return GeminiService(gemini);
});
