// lib/model/use_cases/form_validator.dart
import 'package:flutter/material.dart';

class FormValidator {
  static bool validateForm(BuildContext context, GlobalKey<FormState> formKey) {
    final formState = formKey.currentState;
    if (formState == null) {
      throw Exception('フォームの状態が取得できませんでした');
    }
    return formState.validate();
  }
}
