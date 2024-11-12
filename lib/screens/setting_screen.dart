import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_providers.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/error_dialog.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncAuth = ref.watch(authNotifierProvider);
    final notificationSetting = ref.watch(notificationSettingNotifierProvider);

    // エラー発生時にダイアログを表示するためのリスナー
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        data: (_) {
          //成功時（data状態）になったら画面遷移を行う
          Navigator.pushReplacementNamed(context, '/login');
        },
        error: (error, stack) {
          showErrorDialog(context, error.toString());
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

    final notificationSettingItem = Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('習慣のリマインド通知',
                  style: Theme.of(context).textTheme.titleMedium),
              notificationSetting.when(
                data: (setting) {
                  return Switch(
                    value: setting.isGranted,
                    onChanged: (bool value) async {
                      if (!value) {
                        // 通知設定をオフにした場合は通知をキャンセル
                        await ref
                            .read(notificationSettingNotifierProvider.notifier)
                            .cancelNotification();
                      }
                      await ref
                          .read(notificationSettingNotifierProvider.notifier)
                          .updatePermission(value);
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey.shade400,
                    inactiveTrackColor: Colors.grey.shade200,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => const Text('エラーが発生しました'),
              ),
            ],
          ),
        ));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('設定'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          notificationSettingItem,
          Column(
            children: [
              logoutButton,
              deleteUserButton,
            ],
          ),
        ],
      ),
    );
  }
}
