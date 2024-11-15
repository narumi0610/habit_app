import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/main.dart';
import 'package:habit_app/providers/auth_providers.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/screens/parts/error_dialog.dart';
import 'package:habit_app/screens/password_reset_screen.dart';
import 'package:habit_app/screens/registration_screen.dart';
import 'package:habit_app/utils/validator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAuth = ref.watch(authNotifierProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                    isPassword: true,
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
                      child:
                          const Text('ログインする', style: TextStyle(fontSize: 16)),
                      isDisabled: asyncAuth is AsyncLoading, // ローディング状態の表示
                      loading: asyncAuth is AsyncLoading, // ローディング中は無効化
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final result = await ref
                              .read(authNotifierProvider.notifier)
                              .login(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                          if (result != null) {
                            showErrorDialog(context, result.toString());
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                            );
                          }
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
                              builder: (context) =>
                                  const RegistrationScreen()));
                    },
                    child: const Text('はじめての方はこちら'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
