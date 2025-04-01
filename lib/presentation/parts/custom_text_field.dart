import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/utils/app_color.dart';

final obscureTextProvider = StateProvider<bool>((ref) => true);

class CustomTextField extends ConsumerStatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.text,
    required this.validator,
    super.key,
    this.isPassword = false,
  });
  final TextEditingController controller;
  final String text;
  final FormFieldValidator<String>? validator;
  final bool isPassword;

  @override
  ConsumerState<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends ConsumerState<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final obscureText = ref.watch(obscureTextProvider);
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && obscureText,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: const TextStyle(
          color: AppColor.primary,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.primary,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.primary,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.primary,
                ),
                onPressed: () {
                  ref.read(obscureTextProvider.notifier).state = !obscureText;
                },
              )
            : null,
      ),
      keyboardType: TextInputType.text,
      cursorColor: AppColor.primary,
      validator: widget.validator,
    );
  }
}
