import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/home_state_notifier_provider.dart';
import 'package:habit_app/screens/parts/continuous_days_animation.dart';
import 'package:habit_app/screens/set_goal_screen.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/rounded_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 端末のサイズを取得
    final width = MediaQuery.of(context).size.width;
    final asyncValue = ref.watch(homeAsyncNotifierProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('記録')),
        body: asyncValue.when(
          data: (habit) {
            // 目標設定ボタン
            Widget setGoalButton() {
              // TODO 達成テキストを表示できるようにする
              final aaa = Container(
                margin: const EdgeInsets.only(top: 32),
                child: const Text(GlobalConst.praiseText,
                    style: TextStyle(fontSize: 16)),
              );

              return RoundedButton(
                  title: '目標を設定する',
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetGoalScreen(),
                      ),
                    );
                  });
            }

            // 更新ボタン
            Widget updateButton() {
              if (habit != null) {
                return Bounce(
                  duration: const Duration(milliseconds: 300),
                  onPressed: () async {
                    await ref
                        .watch(homeAsyncNotifierProvider.notifier)
                        .updateHabitDays(habit.id, habit.current_streak);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(64),
                    width: width,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ContinuousDaysAnimation(habit!.current_streak),
                  ),
                );
              } else {
                return Column(
                  children: [
                    const Text('目標を設定しよう！', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 16),
                    RoundedButton(
                        title: '目標を設定する',
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetGoalScreen(),
                            ),
                          );
                        }),
                  ],
                );
              }
            }

            return Container(
              margin: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: habit == null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: const FittedBox(
                          child:
                              Text('目標を設定しよう！', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    updateButton(),
                    setGoalButton(),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return const Center(child: Text('習慣の取得に失敗しました'));
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
