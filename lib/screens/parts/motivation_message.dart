import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/motivation_message_provider.dart';

class MotivationMessage extends ConsumerWidget {
  const MotivationMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AIコメントを 取得
    final message = ref.watch(motivationMessageStateProvider);

    return Text(
      message,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.left,
    );
  }
}
