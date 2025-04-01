import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/gemini_repository.dart';
import '../../utils/prompts/habit_support_prompts.dart';

part 'gemini_service.g.dart';

/// Gemini APIを使用して習慣に関する応援メッセージを生成する
/// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
@riverpod
class GeminiService extends _$GeminiService {
  @override
  Future<String> build({
    required String habitName,
    required int currentStreak,
    String? lastCompletion,
  }) async {
    // プロンプトの生成
    final prompt = HabitSupportPrompts.generateDailyMotivation(
      habitName: habitName,
      currentStreak: currentStreak,
      lastCompletion: lastCompletion,
    );

    // リポジトリを通じてAPIと通信
    final repository = ref.watch(geminiRepositoryProvider.notifier);
    return repository.generateMotivationMessage(prompt);
  }
}
