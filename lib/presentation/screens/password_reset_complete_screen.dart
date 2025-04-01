import 'package:flutter/material.dart';
import 'package:habit_app/presentation/screens/login_screen.dart';
import 'package:habit_app/presentation/parts/custom_button.dart';

class PasswordResetCompleteScreen extends StatelessWidget {
  const PasswordResetCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'パスワードリセット用のメールを送信しました',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              height: 50,
              child: CustomButton.grey(
                isDisabled: false,
                loading: false,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<LoginScreen>(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('戻る', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
