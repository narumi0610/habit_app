import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/habit_providers.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/screens/create_habit_screen.dart';
import 'package:habit_app/screens/parts/continuous_days_animation.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/image_paths.dart';
import 'package:habit_app/utils/rounded_button.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  bool isDialogShown = false;
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 端末のサイズを取得
    final width = MediaQuery.of(context).size.width;
    final asyncGetCurrentHabit = ref.watch(getCurrentHabitProvider);
    final logger = Logger();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('記録'),
      ),
      body: asyncGetCurrentHabit.when(
        data: (habit) {
          //目標達成したかどうか
          final isGoalAchieved =
              habit?.currentStreak == GlobalConst.maxContinuousDays;

          final setGoalButton = Visibility(
            visible: habit == null || isGoalAchieved,
            child: RoundedButton(
              title: '目標を設定する',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<CreateHabitScreen>(
                    builder: (context) => const CreateHabitScreen(),
                  ),
                );
              },
            ),
          );

          final cancelButton = CustomButton.grey(
            onPressed: () {
              Navigator.pop(context);
            },
            isDisabled: false,
            loading: false,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text('キャンセル'),
            ),
          );

          // 目標達成ダイアログを表示
          if (isGoalAchieved &&
              !isDialogShown &&
              !asyncGetCurrentHabit.isLoading) {
            confettiController.play(); // 紙吹雪を再生

            Vibration.vibrate(); // バイブレーション

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ImagePaths.completed,
                      ),
                    ],
                  ),
                  actions: [
                    setGoalButton,
                    const SizedBox(height: 16),
                    cancelButton,
                  ],
                ),
              );
            });
            isDialogShown = true; // 再表示を防止
          }

          final congratulationText = Visibility(
            visible: isGoalAchieved,
            child: const Text('目標達成おめでとう！！！', style: TextStyle(fontSize: 24)),
          );

          final setGoalText = Visibility(
            visible: habit == null,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const FittedBox(
                child: Text(
                  '目標を設定しよう！',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );

          final title = Visibility(
            visible: habit != null,
            child: Text(
              habit?.title ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          );

          // 更新ボタン
          Widget updateButton() {
            if (habit != null) {
              // 更新日が今日かどうか
              final isUpdatedToday =
                  DateTime.now().year == habit.updatedAt.year &&
                      DateTime.now().month == habit.updatedAt.month &&
                      DateTime.now().day == habit.updatedAt.day;
              //　更新日が今日または更新回数が30回以上のときかつ0回目でないとき
              final isUpdated = (isUpdatedToday ||
                      habit.currentStreak >= GlobalConst.maxContinuousDays) &&
                  habit.currentStreak != 0;
              try {
                //iOSでの継続日数を保存するための処理
                Future.wait([
                  // Widgetで扱うデータを保存
                  HomeWidget.saveWidgetData<int>(
                    'currentState',
                    habit.currentStreak,
                  ),
                ]);
              } on PlatformException catch (exception) {
                logger.e(exception);
              }

              try {
                HomeWidget.updateWidget(
                  iOSName: 'habit_app',
                  androidName: 'HomeWidgetGlanceReceiver',
                );
              } on PlatformException catch (exception) {
                logger.e(exception);
              }
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                // 当日更新済みかつ30回以上の場合押せない
                onTap: isUpdated
                    ? () {}
                    : () async {
                        // バイブレーション
                        await HapticFeedback.heavyImpact();

                        // 継続日数を更新
                        await ref.read(
                          updateHabitDaysProvider(
                            habitId: habit.id,
                            currentStreak: habit.currentStreak,
                          ).future,
                        );

                        // 通知を再スケジュール
                        await ref
                            .read(notificationSettingNotifierProvider.notifier)
                            .rescheduleNotification(habit);
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
                              offset: Offset(0, 8),
                            ),
                          ],
                  ),
                  child: ContinuousDaysAnimation(habit.currentStreak),
                ),
              );
            } else {
              return Container();
            }
          }

          final confetti = Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 1,
              numberOfParticles: 40,
              maxBlastForce: 100,
              minBlastForce: 60,
              gravity: 0,
            ),
          );

          return Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          congratulationText,
                          setGoalText,
                          const SizedBox(height: 24),
                          title,
                          const SizedBox(height: 32),
                          updateButton(),
                          const SizedBox(height: 32),
                          setGoalButton,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              confetti,
            ],
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
