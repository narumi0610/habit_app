import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/habit_providers.dart';
import 'package:habit_app/screens/create_habit_screen.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/motivation_message.dart';
import 'package:habit_app/screens/parts/update_button.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:habit_app/utils/image_paths.dart';
import 'package:habit_app/utils/rounded_button.dart';
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
  final logger = Logger();

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
    final width = MediaQuery.sizeOf(context).width;
    final asyncGetCurrentHabit = ref.watch(getCurrentHabitProvider);

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

          final updateButton = habit != null
              ? UpdateButton(habit: habit, width: width)
              : const SizedBox();

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

          final motivationMessage =
              habit != null ? const MotivationMessage() : const SizedBox();

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
                          updateButton,
                          const SizedBox(height: 32),
                          motivationMessage,
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
          logger.e(error);
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
