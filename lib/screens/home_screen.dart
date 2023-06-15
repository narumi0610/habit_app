import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/screens/parts/continuous_days_animation.dart';
import 'package:habit_app/screens/set_goal_screen.dart';
import 'package:habit_app/utils/app_color.dart';
import 'package:home_widget/home_widget.dart';
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
      _currentHabit = habits.isNotEmpty ? habits[0] : null;
    });
  }

  // 習慣を更新
  Future<void> _updateCurrentState() async {
    setState(() {
      realm.write(() {
        _currentHabit!.currentState++;
      });
    });

    try {
      await Future.wait([
        // Widgetで扱うデータを保存
        HomeWidget.saveWidgetData<int>(
            'currentState', _currentHabit!.currentState),
      ]);
    } on PlatformException catch (exception) {
      print(exception);
    }

    try {
      // iOSのWidgetの処理は「iOSName」→「name」の順で探す。
      await HomeWidget.updateWidget(iOSName: 'habit_app');
    } on PlatformException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 端末のサイズを取得
    final width = MediaQuery.of(context).size.width / 1.5;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Bounce(
          duration: const Duration(milliseconds: 300),
          onPressed: () async {
            await _updateCurrentState();
          },
          child: Container(
            width: width,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentHabit != null) ...[
                  Text(_currentHabit!.title,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  ContinuousDaysAnimation(_currentHabit!.currentState),
                  if (_praiseText != null) ...[
                    const SizedBox(height: 16),
                    const Text('AI Praise:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(_praiseText!, style: const TextStyle(fontSize: 16)),
                  ],
                ] else ...[
                  const Text('目標がありません。設定してください',
                      style: TextStyle(fontSize: 24)),
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
        ),
      ),
    );
  }
}
