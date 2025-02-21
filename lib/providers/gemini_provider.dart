import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Gemini API プロバイダー
final geminiProvider = Provider<GenerativeModel>((ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY']!;
  return GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );
});
