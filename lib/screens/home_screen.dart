import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:habit_app/screens/parts/continuous_days_animation.dart';
import 'package:habit_app/screens/set_goal_screen.dart';
import 'package:habit_app/utils/app_color.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/rounded_button.dart';
import 'package:home_widget/home_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Habit? _currentHabit;
  // late Realm realm;

  HomeScreenState() {
    // final config = Configuration.local([Habit.schema]);
    // realm = Realm(config);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentHabit();
  }

  // 現在の習慣を取得
  Future<void> _getCurrentHabit() async {
    // var habits = realm.all<Habit>();

    setState(() {
      // _currentHabit = habits.isNotEmpty ? habits[habits.length - 1] : null;
    });
  }

  // 習慣を更新
  Future<void> _updateCurrentState() async {
    // if ((_currentHabit?.currentState ?? 0) < GlobalConst.maxContinuousDays) {
    //   setState(() {
    //     realm.write(() {
    //       _currentHabit!.currentState++;
    //     });
    //   });
    // }

    try {
      // await Future.wait([
      //   // Widgetで扱うデータを保存
      //   HomeWidget.saveWidgetData<int>(
      //       'currentState', _currentHabit!.currentState),
      // ]);
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
    final width = MediaQuery.of(context).size.width;

    final setGoalButton = RoundedButton(
        title: '目標を設定する',
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetGoalScreen(),
            ),
          );
          print('きた');
          _getCurrentHabit();
        });

    return Scaffold(
      appBar: AppBar(title: const Text('記録')),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: FittedBox(
                  child: Text('_currentHabit?.title 目標を設定しよう！',
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 32),
              // if (_currentHabit != null) ...[
              //   Bounce(
              //     duration: const Duration(milliseconds: 300),
              //     onPressed: () async {
              //       await _updateCurrentState();
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(64),
              //       width: width,
              //       decoration: const BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey,
              //             blurRadius: 16,
              //             offset: Offset(0, 8),
              //           ),
              //         ],
              //       ),
              //       child: ContinuousDaysAnimation(_currentHabit!.currentState),
              //     ),
              //   ),
              // ] else ...[
              //   Column(
              //     children: [
              //       const Text('目標を設定しよう！', style: TextStyle(fontSize: 24)),
              //       const SizedBox(height: 16),
              //       setGoalButton,
              //     ],
              //   ),
              // ],
              // if ((_currentHabit?.currentState ?? 0) ==
              //     GlobalConst.maxContinuousDays) ...[
              //   const SizedBox(height: 32),
              //   const Text(GlobalConst.praiseText,
              //       style: TextStyle(fontSize: 16)),
              //   if (_currentHabit!.currentState ==
              //       GlobalConst.maxContinuousDays)
              //     const SizedBox(height: 24),
              //   setGoalButton
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
