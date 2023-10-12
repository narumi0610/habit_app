import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/main.dart';
import 'package:habit_app/providers/auth_provider.dart';
import 'package:habit_app/screens/login_screen.dart';
import 'package:habit_app/screens/parts/custom_button.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: CustomButton.grey(
                child: const Text('ログアウト'),
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout(
                    onSuccess: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    onError: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('エラーが発生しました'),
                          content: const Text('ログアウトに失敗しました'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('はい'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: false,
                isDisabled: false,
                padding: const EdgeInsets.all(16)),
          )
        ],
      ),
    );
  }
}
