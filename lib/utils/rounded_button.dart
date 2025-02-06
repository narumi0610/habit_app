import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.title,
    required this.onPressed,
    super.key,
  });
  final String title;
  final Future<Null> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      // 最大までwidthを広げる

      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 0),
        backgroundColor: AppColor.primary,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
