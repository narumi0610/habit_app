import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_providers.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/error_dialog.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuth = ref.watch(authNotifierProvider);

    // エラー発生時にダイアログを表示するためのリスナー
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        data: (_) {
          //成功時（data状態）になったら画面遷移を行う
          Navigator.pushReplacementNamed(context, '/login');
        },
        error: (error, stack) {
          showErrorDialog(context, 'エラーが発生しました');
        },
        orElse: () => null,
      );
    });

    final logoutButton = Container(
      margin: const EdgeInsets.all(8),
      child: CustomButton.grey(
        child: const Text('ログアウト'),
        onPressed: () async {
          await ref.read(authNotifierProvider.notifier).logout();
        },
        loading: asyncAuth is AsyncLoading, // ローディング状態の表示
        isDisabled: asyncAuth is AsyncLoading, // ローディング中は無効化
        padding: const EdgeInsets.all(16),
      ),
    );

    final deleteUserButton = Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: TextButton(
          onPressed: () async {
            await showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    title: const Text('退会してもよろしいですか？'),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SimpleDialogOption(
                            child: const Text('はい'),
                            onPressed: () async {
                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .deletedUser();
                            },
                          ),
                          SimpleDialogOption(
                            child: const Text('いいえ'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  );
                });
          },
          child: const Text("退会する"),
        ));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('設定'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          logoutButton,
          deleteUserButton,
        ],
      ),
    );
  }
}
