import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBackground,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => AppColors.primaryColor)),),
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: Colors.green))
                  )
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
  );
}
