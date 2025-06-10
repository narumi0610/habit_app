class GlobalConst {
  static const String appGroupID = 'group.habitFlutter';

  static const int maxContinuousDays = 30;

  static const String praiseText = '30日間達成！おめでとう！！';

  static const String defaultMotivationMessage =
      '君ならできる！！一歩ずつ成長しているよ！！今日も頑張ろう！！!';

  static const String privacyPolicyURL =
      'https://narumi0610.github.io/privacy_policy/privacy_policy.html';

  static const bool isProduction = bool.fromEnvironment('PRODUCTION');

  static const String iOSBundleId = 'com.example.habitFlutterApp';

  static const androidPackageName =
      isProduction ? 'com.flutter.habit_app' : 'com.flutter.habit_app.dev';

  static const actionCodeUrl = isProduction
      ? 'https://habister-5885a.web.app'
      : 'https://habister-dev.web.app';
}
