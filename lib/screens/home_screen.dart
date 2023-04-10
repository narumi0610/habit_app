import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/screens/set_goal_screen.dart';
import 'package:realm/realm.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Habit? _currentHabit;
  String? _praiseText;
  late Realm realm;

  HomeScreenState() {
    final config = Configuration.local([Habit.schema]);
    realm = Realm(config);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentHabit();
  }

  // 現在の習慣を取得
  Future<void> _getCurrentHabit() async {
    var habits = realm.all<Habit>();
    setState(() {
      _currentHabit = habits.first;
    });
  }

  // 習慣を更新
  Future<void> _updateCurrentState() async {
    setState(() {
      realm.write(() {
        _currentHabit!.currentState++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentHabit != null) ...[
              Text('習慣のタイトル: ${_currentHabit!.title}',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text('継続日数: ${_currentHabit!.currentState} days',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateCurrentState,
                child: const Text('今日の目標達成！'),
              ),
              if (_praiseText != null) ...[
                const SizedBox(height: 16),
                const Text('AI Praise:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(_praiseText!, style: const TextStyle(fontSize: 16)),
              ],
            ] else ...[
              const Text('目標がありません。設定してください', style: TextStyle(fontSize: 24)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetGoalScreen(),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                child: const Text('目標を設定する'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
