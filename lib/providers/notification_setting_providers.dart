import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/models/notification/notification_setting.dart';
import 'package:habit_app/repositories/shared_preferences_repository.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

part 'notification_setting_providers.g.dart';

@riverpod
class NotificationSettingNotifier extends _$NotificationSettingNotifier {
  final logger = Logger();
  @override
  Future<NotificationSetting> build() async {
    // SharedPreferencesから通知設定を取得
    final repo = SharedPreferencesRepository();
    final isGranted = await repo.getIsGranted();
    final hour = await repo.getNotificationHour();
    final minute = await repo.getNotificationMinute();

    return NotificationSetting(
      isGranted: isGranted,
      notificationTime: TimeOfDay(hour: hour, minute: minute),
    );
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final repo = SharedPreferencesRepository();

  Future<void> updatePermission({required bool isGranted}) async {
    await repo.setIsGranted(isGranted: isGranted);

    // stateがデータを持っている場合にのみ更新
    state = state.whenData((current) => current.copyWith(isGranted: isGranted));
  }

  tz.TZDateTime nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> zonedSchedule(TZDateTime time, String habitText) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        0,
        '今日の目標を達成しよう！',
        habitText,
        time,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habister-daily',
            'habister-daily',
            channelDescription: 'Habit notification',
            icon: '@mipmap/notification_icon',
          ),
          iOS: DarwinNotificationDetails(
            badgeNumber: 1,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime, //絶対時間で設定
        matchDateTimeComponents:
            DateTimeComponents.dateAndTime, //毎日指定した時間・分で通知を繰り返す
      );
    } on Exception catch (e) {
      logger.e('通知スケジュールエラー: $e');
    }
  }

  // 目標と通知時間を受け取り、通知をスケジュールする
  Future<void> scheduleDailyNotification(
    int hour,
    int minute,
    String habitText,
  ) async {
    final time = nextInstanceOfTime(hour, minute);

    await zonedSchedule(time, habitText);
    await repo.setNotificationHour(hour);
    await repo.setNotificationMinute(minute);
  }

  // 通知を再スケジュールする
  Future<void> rescheduleNotification(HabitModel? habit) async {
    final hour = await repo.getNotificationHour();
    final minute = await repo.getNotificationMinute();
    final title = habit?.title ?? '';
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // 通知をキャンセル
    await cancelNotification();
    // 通知バッジを削除
    await FlutterAppBadger.removeBadge();

    if (habit?.currentStreak != GlobalConst.maxContinuousDays) {
      // 継続日数を更新したので通知を翌日に再スケジュール
      scheduledDate = scheduledDate.add(const Duration(days: 1));

      await zonedSchedule(scheduledDate, title);
    } else {
      // 継続日数が30日の場合は通知をキャンセル
      await cancelNotification();
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<dynamic> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
