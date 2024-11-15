import 'package:flutter/material.dart';

import 'app_color.dart';



class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    hintColor: AppColors.secondary,
    cardColor: AppColors.error,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ),
  );
}
