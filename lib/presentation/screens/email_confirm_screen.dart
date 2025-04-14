import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';

class EmailConfirmScreen extends ConsumerWidget {
  const EmailConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuth = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メール確認'),
      ),
      body: switch (asyncAuth) {
        AsyncData() => Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(32),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '確認メールを送信しました',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '送信したメールのリンクを確認してください。',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        AsyncLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        AsyncError() => const Center(child: Text('エラーが発生しました')),
        _ => const Center(child: Text('予期しないエラーが発生しました'))
      },
    );
  }
}
