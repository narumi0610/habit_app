import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class AppTheme {
  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 52,
      color: AppColor.text,
    ),
    displayMedium: TextStyle(
      fontSize: 48,
      color: AppColor.text,
    ),
    displaySmall: TextStyle(
      fontSize: 42,
      color: AppColor.text,
    ),
    headlineMedium: TextStyle(
      fontSize: 36,
      color: AppColor.text,
    ),
    headlineSmall: TextStyle(
      fontSize: 30,
      color: AppColor.text,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      color: AppColor.text,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      color: AppColor.text,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      color: AppColor.text,
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
      color: AppColor.text,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      color: AppColor.text,
    ),
    bodySmall: TextStyle(
      fontSize: 10,
      color: AppColor.text,
    ),
  );

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'KosugiMaru',
    primaryColor: AppColor.primary,
    // scaffoldBackgroundColor: AppColor.backgroundLight,
    cardTheme: const CardTheme(
      color: AppColor.white,
      elevation: 0,
    ),
    textTheme: _textTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColor.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    splashColor: AppColor.primary,
    // backgroundColor: AppColor.backgroundLight,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFC1C1C1)),
        borderRadius: BorderRadius.zero,
      ),
      errorStyle: TextStyle(
        color: Color(0xFFD21B29),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
      fillColor: Color(0xFFFFFFFF),
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
    ),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: AppColor.yellow,
      brightness: Brightness.light,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColor.yellow),
    appBarTheme:
        const AppBarTheme(backgroundColor: AppColor.primary, elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.white,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: AppColor.lightGray,
    ),
  );
}
