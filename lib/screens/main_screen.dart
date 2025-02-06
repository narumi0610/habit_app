import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/screens/habit_history_screen.dart';
import 'package:habit_app/screens/home_screen.dart';
import 'package:habit_app/screens/setting_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.index = 0});
  final int index;

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const GoalHistoryScreen(),
    const SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    ref.read(notificationSettingNotifierProvider.notifier).requestPermissions();
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
        body: Builder(
          builder: (context) {
            if (user != null) {
              return Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              );
            } else {
              return const Center(child: Text('ログインしていません。'));
            }
          },
        ),
        bottomNavigationBar: NavigationBar(
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
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }
}
