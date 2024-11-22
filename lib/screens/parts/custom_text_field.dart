import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final FormFieldValidator<String>? validator;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.validator,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? obscureText : false,
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
                  setState(() {
                    obscureText = !obscureText;
                  });
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
