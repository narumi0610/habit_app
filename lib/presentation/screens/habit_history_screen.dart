import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/habit_providers.dart';
import 'package:habit_app/presentation/widgets/goal_item.dart';

class GoalHistoryScreen extends ConsumerWidget {
  const GoalHistoryScreen({super.key});

  // 完了した習慣を取得
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsyncValue = ref.watch(getHabitHistoryProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('履歴'),
      ),
      body: historyAsyncValue.when(
        data: (habitHistory) {
          return ListView.builder(
            itemCount: habitHistory.length,
            itemBuilder: (context, index) {
              if (habitHistory.isEmpty) {
                return const Center(
                  child: Text('履歴がありません'),
                );
              }
              final habit = habitHistory[index];
              if (habit == null) {
                return const SizedBox.shrink();
              }
              return GoalItem(habit: habit);
            },
          );
        },
        error: (e, msg) {
          return const Center(child: Text('履歴の取得に失敗しました'));
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
