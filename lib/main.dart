import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/app_links_providers.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';
import 'package:habit_app/model/use_cases/router_provider.dart';
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
  const isProduction = GlobalConst.isProduction;

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

class HabitApp extends ConsumerStatefulWidget {
  const HabitApp({super.key});

  @override
  ConsumerState<HabitApp> createState() => _HabitAppState();
}

class _HabitAppState extends ConsumerState<HabitApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    // AppLinksのストリームを監視
    ref
      ..listen(appLinksStateProvider, (previous, next) async {
        final uri = next.value;
        if (next.hasValue && uri != null) {
          // メールリンクでサインイン
          await ref
              .read(authNotifierProvider.notifier)
              .signInWithEmailLink(emailLink: uri.toString());
        }
      }) // ユーザー状態の変更を監視
      ..listen(userStateProvider, (previous, next) {
        final (user, verified) = next.value ?? (null, false);
        final currentState = ref.read(authNotifierProvider);
        // authの状態変化が完了したかどうか
        final isAuthStateChanged = currentState is AsyncData;
        // ユーザーが存在し、かつ認証済み、かつauthの状態変化が完了した場合、ホーム画面に遷移
        if (user != null && verified && isAuthStateChanged) {
          router.go('/');
        }
      });

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'ハビスター',
      theme: AppTheme.light,
    );
  }
}
