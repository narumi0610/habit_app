import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_providers.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/screens/login_screen.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/error_dialog.dart';
import 'package:habit_app/screens/webview_screen.dart';
import 'package:habit_app/utils/global_const.dart';

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
    const privacyPolicyText = 'プライバシーポリシー';

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
          final result = await ref.read(authNotifierProvider.notifier).logout();
          if (result == null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          } else {
            // エラーメッセージを表示するなどの処理
            showErrorDialog(context, result.toString());
          }
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
                              final result = await ref
                                  .read(authNotifierProvider.notifier)
                                  .deletedUser();
                              if (result == null) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false,
                                );
                              } else {
                                // エラーメッセージを表示するなどの処理
                                showErrorDialog(context, result.toString());
                              }
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

    Container itemContainer(Widget child) {
      return Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      );
    }

    final notificationSettingItem = itemContainer(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('習慣のリマインド通知', style: Theme.of(context).textTheme.titleMedium),
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
                      .updatePermission(isGranted: value);
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
    );

    final privacyPolicyItem = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WebViewScreen(
              url: GlobalConst.privacyPolicyURL,
              title: privacyPolicyText,
            ),
          ),
        );
      },
      child: itemContainer(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(privacyPolicyText,
                style: Theme.of(context).textTheme.titleMedium),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('設定'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  notificationSettingItem,
                  privacyPolicyItem,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                logoutButton,
                const SizedBox(height: 16),
                deleteUserButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
