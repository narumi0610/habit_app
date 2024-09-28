import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/goal_history_async_notifier_provider.dart';
import 'package:habit_app/parts/goal_item.dart';

class GoalHistoryScreen extends ConsumerWidget {
  const GoalHistoryScreen({super.key});

  // 完了した習慣を取得
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalHistoryAsyncNotifierProvider);
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('履歴'),
        ),
        body: state.when(data: (habitHistory) {
          return ListView.builder(
            itemCount: habitHistory.length,
            itemBuilder: (context, index) {
              if (habitHistory[0] == null) {
                return const Column(
                  children: [
                    Text('履歴がありません'),
                  ],
                );
              } else {
                return GoalItem(habit: habitHistory[index]!);
              }
            },
          );
        }, error: (e, msg) {
          return const Center(child: Text('履歴の取得に失敗しました'));
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
