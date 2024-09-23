import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/main.dart';
import 'package:habit_app/providers/auth_provider.dart';
import 'package:habit_app/screens/parts/custom_button.dart';
import 'package:habit_app/screens/parts/custom_text_field.dart';
import 'package:habit_app/utils/validator.dart';

class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainScreen()));
        },
        unauthenticated: (message) => null,
      );
    });

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
                  isDisabled: false,
                  loading: ref.watch(authNotifierProvider).maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      ),
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
