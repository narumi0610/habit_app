import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/main.dart';
import 'package:habit_app/providers/auth_provider.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/screens/password_reset_screen.dart';
import 'package:habit_app/screens/registration_screen.dart';
import 'package:habit_app/utils/validator.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        },
        unauthenticated: (message) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('エラーが発生しました'),
                  content: Text(message!),
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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: emailController,
                  text: 'メールアドレス',
                  validator: Validator().emailValidator,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: passwordController,
                  text: 'パスワード',
                  validator: Validator().passwordValidator,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordResetScreen()));
                    },
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
                      if (formKey.currentState!.validate()) {
                        ref.read(authNotifierProvider.notifier).login(
                              email: emailController.text,
                              password: passwordController.text,
                            );
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
                            builder: (context) => const RegistrationScreen()));
                  },
                  child: const Text('はじめての方はこちら'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
