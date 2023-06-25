import 'package:flutter/material.dart';
import 'package:habit_app/screens/goal_history_screen.dart';
import 'package:habit_app/screens/home_screen.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/theme.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //アプリとウィジェット間でデータを共有するためのグループIDを設定
  HomeWidget.setAppGroupId(GlobalConst.appGroupID);
  runApp(HabitApp());
}

class HabitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit App',
      theme: AppTheme.light,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int index;
  const MainScreen({this.index = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GoalHistoryScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
