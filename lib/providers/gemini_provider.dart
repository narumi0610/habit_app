import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_provider.g.dart';

/// Gemini APIのクライアントを提供するプロバイダー
/// 環境変数からAPIキーを取得し、GenerativeModelを返す
@riverpod
GenerativeModel gemini(GeminiRef ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY']!;
  return GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );
}
