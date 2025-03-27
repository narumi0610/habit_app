import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/screens/login_screen.dart';
import 'package:habit_app/screens/main_screen.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/theme.dart';
import 'package:home_widget/home_widget.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'firebase_options_production.dart' as prod;
import 'firebase_options_staging.dart' as staging;

void main() async {
  tz.initializeTimeZones(); // タイムゾーンの初期化
  tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

  WidgetsFlutterBinding.ensureInitialized();

  // 環境（開発・本番）を判定
  const isProduction = bool.fromEnvironment('PRODUCTION');

  await Future.wait([
    // `.env` ファイルの読み込み
    dotenv.load(),

    // Firebase を初期化（開発用 / 本番用の設定を適用）
    Firebase.initializeApp(
      options: isProduction
          ? prod.DefaultFirebaseOptions.currentPlatform // 本番用
          : staging.DefaultFirebaseOptions.currentPlatform, // 開発用
    ),

    //アプリとウィジェット間でデータを共有するためのグループIDを設定
    HomeWidget.setAppGroupId(GlobalConst.appGroupID),
  ]);

  runApp(
    const ProviderScope(
      child: HabitApp(),
    ),
  );
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ハビスター',
      routes: {
        '/login': (context) => const LoginScreen(),
      },
      theme: AppTheme.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // ローディング中
          }
          if (snapshot.hasData) {
            return const MainScreen(); // ログイン済み
          }
          return const LoginScreen(); // 未ログイン
        },
      ),
    );
  }
}
