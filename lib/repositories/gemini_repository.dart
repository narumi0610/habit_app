import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/gemini_provider.dart';
import '../utils/global_const.dart';

part 'gemini_repository.g.dart';

/// Gemini APIとの通信をするリポジトリ
@riverpod
class GeminiRepository extends _$GeminiRepository {
  @override
  Future<String> build() => Future.value('');

  /// Gemini APIを使用して応援メッセージを生成する
  /// [prompt] 生成に使用するプロンプト
  /// 返り値: 生成されたメッセージ。エラー時はデフォルトメッセージを返す
  Future<String> generateMotivationMessage(String prompt) async {
    final gemini = ref.watch(geminiProvider);
    try {
      final content = [Content.text(prompt)];
      final response = await gemini.generateContent(content);
      return response.text ?? GlobalConst.defaultMotivationMessage;
    } catch (e) {
      return GlobalConst.defaultMotivationMessage;
    }
  }
}
