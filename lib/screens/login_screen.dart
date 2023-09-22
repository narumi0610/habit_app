import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_provider.dart';
import 'package:habit_app/screens/home_screen.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/screens/registration_screen.dart';
import 'package:habit_app/utils/app_color.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
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
                  title: const Text('ログインに失敗しました'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('はい'),
                    ),
                  ],
                )),
      );
    });
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(16),
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // TODO パスワード再設定画面へ遷移
                  child: const Text('パスワードをお忘れですか？'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton.primary(
                  child: const Text('ログインする', style: TextStyle(fontSize: 16)),
                  isDisabled: false,
                  loading: ref.watch(authNotifierProvider).maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      ),
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      ref.read(authNotifierProvider.notifier).login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: const Text('はじめての方はこちら'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
