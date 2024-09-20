import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/home_state_notifier_provider.dart';
import 'package:habit_app/screens/parts/continuous_days_animation.dart';
import 'package:habit_app/screens/set_goal_screen.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/rounded_button.dart';
import 'package:home_widget/home_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 端末のサイズを取得
    final width = MediaQuery.of(context).size.width;
    final asyncValue = ref.watch(homeAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('記録'),
      ),
      body: asyncValue.when(
        data: (habit) {
          const setGoalText = Text('目標を設定しよう！', style: TextStyle(fontSize: 16));

          final setGoalButton = Visibility(
            visible: habit == null ||
                habit.current_streak == GlobalConst.maxContinuousDays,
            child: Container(
              margin: const EdgeInsets.only(top: 32),
              child: RoundedButton(
                title: '目標を設定する',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetGoalScreen(),
                    ),
                  );
                },
              ),
            ),
          );

          final congratulationText = Visibility(
            visible: habit?.current_streak == GlobalConst.maxContinuousDays,
            child: const Text('目標達成おめでとう！', style: TextStyle(fontSize: 24)),
          );

          // 更新ボタン
          Widget updateButton() {
            if (habit != null) {
              // 更新日が今日かどうか
              bool isUpdatedToday =
                  DateTime.now().year == habit.updated_at.year &&
                      DateTime.now().month == habit.updated_at.month &&
                      DateTime.now().day == habit.updated_at.day;
              //　更新日が今日または更新回数が30回以上のときかつ0回目でないとき
              bool isUpdated = (isUpdatedToday ||
                      habit.current_streak >= GlobalConst.maxContinuousDays) &&
                  habit.current_streak != 0;
              try {
                Future.wait([
                  // Widgetで扱うデータを保存
                  HomeWidget.saveWidgetData<int>(
                      'currentState', habit.current_streak),
                ]);
              } on PlatformException catch (exception) {
                print(exception);
              }

              try {
                // iOSのWidgetの処理は「iOSName」→「name」の順で探す。
                HomeWidget.updateWidget(iOSName: 'habit_app');
              } on PlatformException catch (exception) {
                print(exception);
              }
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                // 当日更新済みかつ30回以上の場合押せない
                onTap: isUpdated
                    ? () {}
                    : () {
                        ref
                            .watch(homeAsyncNotifierProvider.notifier)
                            .updateHabitDays(habit.id, habit.current_streak);
                        ref.refresh(homeAsyncNotifierProvider);
                      },
                child: Container(
                  padding: const EdgeInsets.all(64),
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: isUpdated
                        ? null
                        : [
                            const BoxShadow(
                                color: Colors.grey,
                                blurRadius: 16,
                                offset: Offset(0, 8))
                          ],
                  ),
                  child: ContinuousDaysAnimation(habit.current_streak),
                ),
              );
            } else {
              return Container();
            }
          }

          return Container(
            margin: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  congratulationText,
                  Visibility(
                    visible: habit == null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: const FittedBox(
                        child: setGoalText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  updateButton(),
                  setGoalButton,
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
      ),
    );
  }
}
