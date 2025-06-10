import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_provider.g.dart';

/// Gemini APIのクライアントを提供するプロバイダー
/// 環境変数からAPIキーを取得し、GenerativeModelを返す
@riverpod
GenerativeModel gemini(Ref ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    throw Exception('GEMINI_API_KEYが設定されていません');
  }
  return GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );
}
