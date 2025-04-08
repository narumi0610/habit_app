import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_repository.g.dart';

@riverpod
class SharedPreferencesRepository extends _$SharedPreferencesRepository {
  static const String isGrantedKey = 'isGranted';
  static const String notificationHourKey = 'notification_hour';
  static const String notificationMinuteKey = 'notification_minute';
  static const String emailForSignInKey = 'emailForSignIn';

  @override
  FutureOr<SharedPreferences> build() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setIsGranted({required bool isGranted}) async {
    final prefs = await future; // キャッシュされたインスタンスを再利用
    await prefs.setBool(isGrantedKey, isGranted);
  }

  Future<bool> getIsGranted() async {
    final prefs = await future;
    return prefs.getBool(isGrantedKey) ?? false;
  }

  Future<void> setNotificationHour(int hour) async {
    final prefs = await future;
    await prefs.setInt(notificationHourKey, hour);
  }

  Future<int> getNotificationHour() async {
    final prefs = await future;
    return prefs.getInt(notificationHourKey) ?? 8;
  }

  Future<void> setNotificationMinute(int minute) async {
    final prefs = await future;
    await prefs.setInt(notificationMinuteKey, minute);
  }

  Future<int> getNotificationMinute() async {
    final prefs = await future;
    return prefs.getInt(notificationMinuteKey) ?? 0;
  }

  Future<void> setEmailForSignIn(String email) async {
    final prefs = await future;
    await prefs.setString(emailForSignInKey, email);
  }

  Future<String?> getEmailForSignIn() async {
    final prefs = await future;
    return prefs.getString(emailForSignInKey);
  }

  Future<void> removeEmailForSignIn() async {
    final prefs = await future;
    await prefs.remove(emailForSignInKey);
  }
}
