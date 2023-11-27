import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBackground,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => AppColors.primaryColor)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.primaryBackground,
      iconTheme: IconThemeData(color: AppColors.primaryText),
      titleTextStyle: TextStyle(
        color: AppColors.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return AppColors.primaryColor;
          },
        ),
        overlayColor: MaterialStateColor.resolveWith(
          (states) => Colors.transparent,
        ),
      ),
    ),
  );
}
