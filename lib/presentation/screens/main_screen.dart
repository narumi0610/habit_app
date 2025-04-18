import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/notification_setting_providers.dart';
import 'package:habit_app/presentation/screens/habit_history_screen.dart';
import 'package:habit_app/presentation/screens/home_screen.dart';
import 'package:habit_app/presentation/screens/setting_screen.dart';

// selectedIndexの状態を管理するProvider
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.index = 0});
  final int index;

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const HabitHistoryScreen(),
    const SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    ref.read(selectedIndexProvider.notifier).state = widget.index;
    ref.read(notificationSettingNotifierProvider.notifier).requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final selectedIndex = ref.watch(selectedIndexProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Builder(
          builder: (context) {
            if (user != null) {
              return Center(
                child: _widgetOptions.elementAt(selectedIndex),
              );
            } else {
              return const Center(child: Text('ログインしていません。'));
            }
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade200,
                width: 0.6,
              ),
            ),
          ),
          child: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'ホーム',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: '履歴',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: '設定',
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              ref.read(selectedIndexProvider.notifier).state = index;
            },
          ),
        ),
      ),
    );
  }
}
