// lib/model/use_cases/form_validator.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FormValidator {
  static bool validateForm(BuildContext context, GlobalKey<FormState> formKey) {
    final formState = formKey.currentState;
    if (formState == null) {
      Logger().e('フォームの状態が取得できませんでした');
      return false;
    }
    return formState.validate();
  }
}
