import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/main.dart';
import 'package:habit_app/providers/goal_provider.dart';
import 'package:habit_app/providers/home_state_notifier_provider.dart';
import 'package:habit_app/utils/rounded_button.dart';

import '../utils/app_color.dart';

class SetGoalScreen extends ConsumerWidget {
  const SetGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController goalController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('目標を設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLength: 20,
                style: const TextStyle(color: AppColor.text),
                controller: goalController,
                decoration: const InputDecoration(
                    hintText: '例)本を1ページ読む',
                    hintStyle: TextStyle(color: AppColor.lightGray),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '目標を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              RoundedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      // 非同期処理が完了するのを待つ
                      await ref.read(
                          setGoalProvider(form: goalController.text).future);

                      // 成功時の処理
                      ref.refresh(homeAsyncNotifierProvider);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MainScreen(index: 0),
                        ),
                        (_) => false,
                      );
                    } catch (error) {
                      // エラー時の処理
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('目標の設定に失敗しました'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('はい'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                title: '決定する',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
