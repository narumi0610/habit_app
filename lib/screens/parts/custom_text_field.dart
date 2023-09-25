import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
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
      ),
      keyboardType: TextInputType.text,
      cursorColor: AppColor.primary,
      validator: validator,
    );
  }
}
