import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/screens/login_screen.dart';
import 'package:habit_app/screens/main_screen.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/theme.dart';
import 'package:home_widget/home_widget.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'firebase_options.dart';

void main() async {
  tz.initializeTimeZones(); // タイムゾーンの初期化
  tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

  WidgetsFlutterBinding.ensureInitialized();

  // Firebase を初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //アプリとウィジェット間でデータを共有するためのグループIDを設定
  await HomeWidget.setAppGroupId(GlobalConst.appGroupID);
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
