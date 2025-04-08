import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/use_cases/auth_providers.dart';
import 'package:habit_app/presentation/screens/main_screen.dart';
import 'package:habit_app/presentation/widgets/custom_button.dart';
import 'package:habit_app/presentation/widgets/custom_text_field.dart';
import 'package:habit_app/presentation/widgets/error_dialog.dart';

class LoginConfirmScreen extends ConsumerStatefulWidget {
  const LoginConfirmScreen({
    required this.email,
    super.key,
  });

  final String email;

  @override
  LoginConfirmScreenState createState() => LoginConfirmScreenState();
}

class LoginConfirmScreenState extends ConsumerState<LoginConfirmScreen> {
  final emailLinkController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncAuth = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メール確認'),
      ),
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
                  const Text(
                    '確認メールを送信しました',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '送信したメールのリンクを確認してください。',
                    textAlign: TextAlign.center,
                  ),

                  // TODO DeepLink対応が完了したら削除　ここから
                  const SizedBox(height: 32),
                  const Text(
                    'メールリンク認証',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: emailLinkController,
                    text: 'リンクをここに貼り付け',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'リンクを入力してください' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton.primary(
                      isDisabled: asyncAuth is AsyncLoading,
                      loading: asyncAuth is AsyncLoading,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final result = await ref
                              .read(authNotifierProvider.notifier)
                              .signInWithEmailLink(
                                email: widget.email,
                                emailLink: emailLinkController.text,
                              );

                          if (!context.mounted) return;

                          if (result != null) {
                            showErrorDialog(context, result);
                          } else {
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<MainScreen>(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'リンクで認証',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  // TODO DeepLink対応が完了したら削除　ここまで
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
