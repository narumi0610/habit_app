import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';
import 'package:habit_app/model/use_cases/form_validator.dart';
import 'package:habit_app/presentation/screens/registration_confirm_screen.dart';
import 'package:habit_app/presentation/widgets/custom_button.dart';
import 'package:habit_app/presentation/widgets/custom_text_field.dart';
import 'package:habit_app/presentation/widgets/error_dialog.dart';
import 'package:habit_app/utils/validator.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAuth = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
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
                      loading: asyncAuth is AsyncLoading, // ローディング状態の表示
                      isDisabled: asyncAuth is AsyncLoading, // ローディング中は無効化
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
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<RegistrationConfirmScreen>(
                              builder: (context) => RegistrationConfirmScreen(
                                email: emailController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        '新規登録用リンクを送信',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
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
