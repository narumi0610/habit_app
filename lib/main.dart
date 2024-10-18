import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/screens/setting_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/screens/habit_history_screen.dart';
import 'package:habit_app/screens/home_screen.dart';
import 'package:habit_app/screens/login_screen.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/theme.dart';
import 'package:home_widget/home_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase を初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //アプリとウィジェット間でデータを共有するためのグループIDを設定
  HomeWidget.setAppGroupId(GlobalConst.appGroupID);
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
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ハビスター',
      theme: AppTheme.light,
      home: user == null ? const LoginScreen() : const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int index;
  const MainScreen({super.key, this.index = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const GoalHistoryScreen(),
    const SettingScreen()
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Builder(builder: (context) {
          if (user != null) {
            return Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            );
          } else {
            return const Center(child: Text("ログインしていません。"));
          }
        }),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '履歴',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '設定',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
