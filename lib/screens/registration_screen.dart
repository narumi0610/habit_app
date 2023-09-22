import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_provider.dart';
import 'package:habit_app/screens/home_screen.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/utils/app_color.dart';
import 'package:habit_app/viewmodels/auth_viewmodel.dart';

class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        unauthenticated: (message) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('新規登録に失敗しました'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('はい'),
                    ),
                  ],
                )),
      );
    });
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: emailController,
              text: 'メールアドレス',
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: passwordController,
              text: 'パスワード',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton.primary(
                child: const Text('新規登録をする', style: TextStyle(fontSize: 16)),
                isDisabled: false,
                loading: ref.watch(authNotifierProvider).maybeWhen(
                      orElse: () => false,
                      loading: () => true,
                    ),
                onPressed: () {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    ref.read(authNotifierProvider.notifier).signUp(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
