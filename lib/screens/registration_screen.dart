import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/auth_providers.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/utils/validator.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: Container(
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
              CustomTextField(
                isPassword: true,
                controller: passwordController,
                text: 'パスワード',
                validator: Validator().passwordValidator,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton.primary(
                  child: const Text('新規登録をする', style: TextStyle(fontSize: 16)),
                  loading: asyncAuth is AsyncLoading, // ローディング状態の表示
                  isDisabled: asyncAuth is AsyncLoading, // ローディング中は無効化
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ref.read(authNotifierProvider.notifier).signUp(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
