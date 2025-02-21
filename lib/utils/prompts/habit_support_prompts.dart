import 'package:habit_app/utils/global_const.dart';

class HabitSupportPrompts {
  static String generateDailyMotivation({
    required String habitName,
    required int currentStreak,
    String? lastCompletion,
  }) {
    return '''
あなたはDuolingoのDuo風AIアシスタントです。ユーザーの習慣継続を促す励ましメッセージを50文字以内で作成。30日チャレンジを意識し、簡潔に。絵文字1つまで。

状況:

目標：$habitName
継続日数：$currentStreak日
期間：${GlobalConst.maxContinuousDays}日間

出力：

50文字以内。Duo風で励みになる大げさでユニークなメッセージ。科学的根拠に基づき、30日チャレンジを意識した応援を。名言を入れることも可。
    ''';
  }
}
