import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';
import 'package:habit_app/model/use_cases/form_validator.dart';
import 'package:habit_app/presentation/screens/email_confirm_screen.dart';
import 'package:habit_app/presentation/screens/registration_screen.dart';
import 'package:habit_app/presentation/widgets/custom_button.dart';
import 'package:habit_app/presentation/widgets/custom_text_field.dart';
import 'package:habit_app/presentation/widgets/error_dialog.dart';
import 'package:habit_app/utils/validator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAuth = ref.watch(authNotifierProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(32),
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
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton.primary(
                        isDisabled: asyncAuth is AsyncLoading, // ローディング状態の表示
                        loading: asyncAuth is AsyncLoading, // ローディング中は無効化
                        onPressed: () async {
                          // フォームのバリデーション
                          if (!FormValidator.validateForm(context, formKey)) {
                            return;
                          }

                          final result = await ref
                              .read(authNotifierProvider.notifier)
                              .sendSignInLinkToEmail(
                                email: emailController.text,
                              );

                          if (!context.mounted) return;

                          if (result != null) {
                            showErrorDialog(context, result);
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute<EmailConfirmScreen>(
                                builder: (context) =>
                                    const EmailConfirmScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'ログインリンクを送信',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<RegistrationScreen>(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('はじめての方はこちら'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
