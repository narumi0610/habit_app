import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';
import 'package:habit_app/presentation/widgets/custom_button.dart';
import 'package:habit_app/presentation/widgets/custom_text_field.dart';
import 'package:habit_app/presentation/widgets/error_dialog.dart';
import 'package:habit_app/utils/validator.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  PasswordResetScreenState createState() => PasswordResetScreenState();
}

class PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  late TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAuth = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        data: (_) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('パスワードリセット用のメールを送信しました。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('戻る'),
                ),
              ],
            ),
          );
        },
        error: (error, stack) {
          showErrorDialog(context, error.toString());
        },
        orElse: () => null,
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text('パスワードを変更する', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                const Text('メールアドレスを入力してください。', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: emailController,
                  text: 'メールアドレス',
                  validator: Validator().emailValidator,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: CustomButton.primary(
                loading: asyncAuth is AsyncLoading, // ローディング状態の表示
                isDisabled: asyncAuth is AsyncLoading, // ローディング中は無効化
                onPressed: () {
                  ref
                      .read(authNotifierProvider.notifier)
                      .passwordReset(email: emailController.text);
                },
                padding: const EdgeInsets.all(10),
                child: const Text('パスワードを変更する', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
