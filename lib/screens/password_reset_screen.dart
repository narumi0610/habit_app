import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_provider.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/screens/password_reset_complete_screen.dart';
import 'package:habit_app/utils/validator.dart';

class PasswordResetScreen extends ConsumerWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();

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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  child:
                      const Text('パスワードを変更する', style: TextStyle(fontSize: 16)),
                  isDisabled: false,
                  loading: false,
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).passwordReset(
                        email: emailController.text,
                        onSuccess: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             const PasswordResetCompleteScreen()));

                          showDialog(
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
                        onError: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('エラーが発生しました'),
                              content: const Text('パスワードリセット用のメールの送信に失敗しました。'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('はい'),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  padding: EdgeInsets.all(10)),
            ),
          ],
        ),
      ),
    );
  }
}
