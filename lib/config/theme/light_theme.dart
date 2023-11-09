import 'package:flutter/material.dart';

import 'app_colors.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBackground, // Color de fondo para AppBar
    scaffoldBackgroundColor: AppColors.primaryBackground,
    appBarTheme: const AppBarTheme(
      elevation: 0, // Sin elevación en el AppBar
      backgroundColor: AppColors.primaryBackground, // Color de fondo del AppBar
      iconTheme: IconThemeData(color: AppColors.primaryText), // Color del icono de retroceso
      titleTextStyle: TextStyle(
          color: AppColors.primaryText, // Color del texto del AppBar
          fontSize: 20, // Tamaño de fuente del título del AppBar
          fontWeight: FontWeight.bold,
        ),
    ),
  );
}