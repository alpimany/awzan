import 'package:flutter/material.dart';

abstract final class AppColors {
  static const bg        = Color(0xFF1A1208);
  static const surface   = Color(0xFF221A0E);
  static const card      = Color(0xFF2A2010);
  static const border    = Color(0xFF3D3018);
  static const gold      = Color(0xFFD4A847);
  static const goldLight = Color(0xFFEDCB7A);
  static const textSec   = Color(0xFFAA9870);
  static const textPri   = Color(0xFFF5EDD8);
  static const red       = Color(0xFFD95F5F);
  static const green     = Color(0xFF5BBF85);
  static const blue      = Color(0xFF7AAFE8);
  static const inputBg   = Color(0xFF120E05);
}

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: 'Scheherazade',
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.gold,
      onPrimary: AppColors.bg,
      error: AppColors.red,
    ),
  );
}