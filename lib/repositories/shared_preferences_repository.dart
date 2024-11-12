import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  static const String ISGRANTEDKEY = 'isGranted';
  static const String NOTIFICATIONHOURKEY = 'notification_hour';
  static const String NOTIFICATIONMINUTEKEY = 'notification_minute';

  Future<void> setIsGranted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ISGRANTEDKEY, value);
  }

  Future<bool> getIsGranted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ISGRANTEDKEY) ?? false;
  }

  Future<void> setNotificationHour(int hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NOTIFICATIONHOURKEY, hour);
  }

  Future<int> getNotificationHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(NOTIFICATIONHOURKEY) ?? 8;
  }

  Future<void> setNotificationMinute(int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NOTIFICATIONMINUTEKEY, minute);
  }

  Future<int> getNotificationMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(NOTIFICATIONMINUTEKEY) ?? 0;
  }
}
