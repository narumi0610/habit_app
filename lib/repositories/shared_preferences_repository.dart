import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  static const String isGrantedKey = 'isGranted';
  static const String notificationHourKey = 'notification_hour';
  static const String notificationMinuteKey = 'notification_minute';

  Future<void> setIsGranted({required bool isGranted}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(isGrantedKey, isGranted);
  }

  Future<bool> getIsGranted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(isGrantedKey) ?? false;
  }

  Future<void> setNotificationHour(int hour) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(notificationHourKey, hour);
  }

  Future<int> getNotificationHour() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(notificationHourKey) ?? 8;
  }

  Future<void> setNotificationMinute(int minute) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(notificationMinuteKey, minute);
  }

  Future<int> getNotificationMinute() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(notificationMinuteKey) ?? 0;
  }
}
