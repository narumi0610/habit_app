import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini_service.dart';
import '../../utils/global_const.dart';

/// AIコメントの状態を管理するプロバイダー
/// デフォルトメッセージから開始し、新しいメッセージが生成されると更新される
final motivationMessageStateProvider =
    StateProvider<String>((ref) => GlobalConst.defaultMotivationMessage);

/// AIコメントを取得するプロバイダー
/// GeminiServiceを使用して新しいメッセージを生成する
final motivationMessageProvider = FutureProvider.family<String,
    ({String habitTitle, int currentStreak, String lastCompletion})>(
  (ref, params) async {
    return ref.watch(
      geminiServiceProvider(
        habitName: params.habitTitle,
        currentStreak: params.currentStreak,
        lastCompletion: params.lastCompletion,
      ).future,
    );
  },
);
