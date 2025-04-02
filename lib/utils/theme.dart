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
    splashColor: AppColor.primary,
    brightness: Brightness.light,
    fontFamily: 'NotoSansJP',
    primaryColor: AppColor.primary,
    cardTheme: const CardTheme(
      color: AppColor.white,
      elevation: 0,
    ),
    textTheme: _textTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColor.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFC1C1C1)),
        borderRadius: BorderRadius.zero,
      ),
      errorStyle: TextStyle(
        color: Color(0xFFD21B29),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      fillColor: Color(0xFFFFFFFF),
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
    ),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: AppColor.yellow,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColor.yellow),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: AppColor.primary, fontSize: 20),
      iconTheme: IconThemeData(color: AppColor.primary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.white,
      indicatorColor: AppColor.primary, // 選択時の背景色
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColor.white); // 選択時のアイコン色
        }
        return const IconThemeData(color: AppColor.lightGray); // 非選択時のアイコン色
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: Colors.grey[600],
          ); // 選択時のテキスト色
        }
        return const TextStyle(color: AppColor.lightGray); // 非選択時のテキスト色
      }),
      overlayColor:
          WidgetStateProperty.all(Colors.transparent), // タップ時のオレンジ色を無効化
    ),
  );
}
