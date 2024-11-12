import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'notification_setting.freezed.dart';

@freezed
class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required bool isGranted,
    required TimeOfDay notificationTime,
  }) = _NotificationSetting;
}
