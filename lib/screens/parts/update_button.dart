import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/providers/habit_providers.dart';
import 'package:habit_app/providers/motivation_message_provider.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/screens/parts/continuous_days_animation.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';

class UpdateButton extends ConsumerWidget {
  const UpdateButton({
    required this.habit,
    required this.width,
    super.key,
  });

  final HabitModel habit;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();

    final isUpdatedToday = DateTime.now().year == habit.updatedAt.year &&
        DateTime.now().month == habit.updatedAt.month &&
        DateTime.now().day == habit.updatedAt.day;

    final isUpdated = (isUpdatedToday ||
            habit.currentStreak >= GlobalConst.maxContinuousDays) &&
        habit.currentStreak != 0;

    try {
      // iOSのWidgetデータ保存処理
      Future.wait([
        HomeWidget.saveWidgetData<int>('currentState', habit.currentStreak),
        HomeWidget.saveWidgetData<String>('habitTitle', habit.title),
      ]);

      // ウィジェットの更新をトリガー
      HomeWidget.updateWidget(
        iOSName: 'habit_app',
        androidName: 'HomeWidgetGlanceReceiver',
      );
    } on PlatformException catch (exception) {
      logger.e(exception);
    }

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: isUpdated
          ? null
          : () async {
              await HapticFeedback.heavyImpact();

              // 習慣データの更新
              await ref.read(
                updateHabitDaysProvider(
                  habitId: habit.id,
                  currentStreak: habit.currentStreak,
                ).future,
              );

              // 通知の再スケジュール
              await ref
                  .read(notificationSettingNotifierProvider.notifier)
                  .rescheduleNotification(habit);

              // AIコメントの更新
              try {
                ref.invalidate(motivationMessageProvider);
                final message = await ref.read(
                  motivationMessageProvider(
                    (
                      habitTitle: habit.title,
                      currentStreak: habit.currentStreak,
                      lastCompletion: DateTime.now().toString(),
                    ),
                  ).future,
                );
                ref.read(motivationMessageStateProvider.notifier).state =
                    message;
              } catch (e) {
                logger.e('Error getting motivation message: $e');
              }
            },
      child: Container(
        padding: const EdgeInsets.all(64),
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: isUpdated
              ? null
              : [
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
        ),
        child: ContinuousDaysAnimation(habit.currentStreak),
      ),
    );
  }
}
