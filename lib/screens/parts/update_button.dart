import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/providers/habit_providers.dart';
import 'package:habit_app/providers/motivation_message_provider.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/providers/update_status_provider.dart';
import 'package:habit_app/utils/app_color.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';

class UpdateButton extends ConsumerStatefulWidget {
  const UpdateButton({
    required this.habit,
    required this.width,
    super.key,
  });

  final HabitModel habit;
  final double width;

  @override
  UpdateButtonState createState() => UpdateButtonState();
}

class UpdateButtonState extends ConsumerState<UpdateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    try {
      // Widgetデータ保存処理
      Future.wait([
        HomeWidget.saveWidgetData<int>(
          'currentState',
          widget.habit.currentStreak,
        ),
        HomeWidget.saveWidgetData<String>('habitTitle', widget.habit.title),
      ]);

      HomeWidget.updateWidget(
        iOSName: 'habit_app',
        androidName: 'HomeWidgetGlanceReceiver',
      );
    } on PlatformException catch (exception) {
      Logger().e(exception);
    }

    //現在の進捗率
    final progressPercentage =
        widget.habit.currentStreak / GlobalConst.maxContinuousDays;

    //progress を 1.0 で制限することで、最大値を超えないようにする
    progress = progressPercentage > 1.0 ? 1.0 : progressPercentage;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: progress,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // アニメーションを開始
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      await HapticFeedback.heavyImpact();
    }

    // 習慣データの更新
    await ref.read(
      updateHabitDaysProvider(
        habitId: widget.habit.id,
        currentStreak: widget.habit.currentStreak,
      ).future,
    );

    // 通知の再スケジュール
    await ref
        .read(notificationSettingNotifierProvider.notifier)
        .rescheduleNotification(widget.habit);

    // AIコメントの更新
    try {
      ref.invalidate(motivationMessageProvider);
      final message = await ref.read(
        motivationMessageProvider(
          (
            habitTitle: widget.habit.title,
            currentStreak: widget.habit.currentStreak,
            lastCompletion: DateTime.now().toString(),
          ),
        ).future,
      );
      ref.read(motivationMessageStateProvider.notifier).state = message;
    } catch (e) {
      Logger().e('Error getting motivation message: $e');
    }
    try {
      // 更新後の値を取得
      final updatedStreak = widget.habit.currentStreak;

      // データ保存
      await HomeWidget.saveWidgetData<int>('currentState', updatedStreak);
      await HomeWidget.saveWidgetData<String>('habitTitle', widget.habit.title);

      // ウィジェットの更新
      await HomeWidget.updateWidget(
        iOSName: 'habit_app',
        androidName: 'HomeWidgetGlanceReceiver',
      );

      print('ウィジェット更新完了: $updatedStreak');
    } catch (e) {
      Logger().e('HomeWidget更新エラー: $e');
    }

    // 進捗アニメーション開始
    setState(() {
      _progressAnimation = Tween<double>(
        begin: progress,
        end: (widget.habit.currentStreak + 1) / GlobalConst.maxContinuousDays,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
      );

      _animationController
        ..reset()
        ..forward();
    });

    // isUpdatedToday を更新
    ref.invalidate(isUpdatedTodayProvider);

    print('更新完了');
  }

  @override
  Widget build(BuildContext context) {
    final isUpdatedToday = ref.watch(
      isUpdatedTodayProvider(
        UpdateStatusParams(
          updatedAt: widget.habit.updatedAt,
          currentStreak: widget.habit.currentStreak,
        ),
      ),
    );

    return InkWell(
      key: const Key('update_button'), // テスト用のキーを追加
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: isUpdatedToday ? null : _onTap,
      child: SizedBox(
        width: widget.width,
        height: widget.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // インジケーター
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.width, widget.width),
                  painter: RoundedProgressPainter(
                    backgroundColor: Colors.grey.shade200,
                    progressColor:
                        isUpdatedToday ? AppColor.primary : Colors.grey,
                    progress: _progressAnimation.value,
                    strokeWidth: widget.width * 0.08,
                  ),
                );
              },
            ),
            // テキストの背景を白にする
            Container(
              width: widget.width * 0.65,
              height: widget.width * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.habit.currentStreak}',
                  style: TextStyle(
                    fontSize: widget.width * 0.3,
                    color: AppColor.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// プログレスインジケーターを描画
class RoundedProgressPainter extends CustomPainter {
  RoundedProgressPainter({
    required this.backgroundColor,
    required this.progressColor,
    required this.progress,
    required this.strokeWidth,
  });
  final Color backgroundColor;
  final Color progressColor;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth * 1.5) / 2;

    // 背景の円を描画
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 進捗の円弧を描画
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // 上部から開始
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(RoundedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
