import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_app/model/entities/habit/habit_model.dart';
import 'package:habit_app/model/entities/notification/notification_setting.dart';
import 'package:habit_app/model/repositories/shared_preferences_repository.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

part 'notification_setting_providers.g.dart';

@riverpod
class NotificationSettingNotifier extends _$NotificationSettingNotifier {
  final logger = Logger();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<NotificationSetting> build() async {
    final repo = ref.read(sharedPreferencesRepositoryProvider.notifier);

    final isGranted = await repo.getIsGranted();
    final hour = await repo.getNotificationHour();
    final minute = await repo.getNotificationMinute();

    return NotificationSetting(
      isGranted: isGranted,
      notificationTime: TimeOfDay(hour: hour, minute: minute),
    );
  }

  Future<void> updatePermission({required bool isGranted}) async {
    final repo = ref.read(sharedPreferencesRepositoryProvider.notifier);
    await repo.setIsGranted(isGranted: isGranted);

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
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      logger.e('通知スケジュールエラー: $e');
    }
  }

  Future<void> scheduleDailyNotification(
    int hour,
    int minute,
    String habitText,
  ) async {
    final time = nextInstanceOfTime(hour, minute);
    await zonedSchedule(time, habitText);

    final repo = ref.read(sharedPreferencesRepositoryProvider.notifier);
    await repo.setNotificationHour(hour);
    await repo.setNotificationMinute(minute);
  }

  Future<void> rescheduleNotification(HabitModel? habit) async {
    final repo = ref.read(sharedPreferencesRepositoryProvider.notifier);
    final hour = await repo.getNotificationHour();
    final minute = await repo.getNotificationMinute();
    final title = habit?.title ?? '';
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    await cancelNotification();
    await FlutterAppBadgeControl.removeBadge();

    if (habit?.currentStreak != GlobalConst.maxContinuousDays) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      await zonedSchedule(scheduledDate, title);
    } else {
      await cancelNotification();
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
