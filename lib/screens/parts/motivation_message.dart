import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/motivation_message_provider.dart';
import 'package:habit_app/utils/app_color.dart';

class MotivationMessage extends ConsumerWidget {
  const MotivationMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AIコメントを取得して余白を削除
    final message = ref.watch(motivationMessageStateProvider).trim();

    return Bubble(
      elevation: 0,
      radius: const Radius.circular(15),
      padding: const BubbleEdges.all(16),
      alignment: Alignment.center,
      nip: BubbleNip.rightTop,
      color: AppColor.primary.withValues(alpha: 0.2), // 0.2 * 255 ≈ 51
      child: Text(
        message,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.left,
      ),
    );
  }
}
